+++
title = "A debugging story"
date = 2024-07-17 07:00:00
+++
**11/1/1446**

---

For some reason I wanted to "port" Jupyter Echo Kernel to Deno using
[deno-python](https://github.com/denosaurs/deno_python). It shouldn't be too
hard I already have relatively complex projects using it:
[Stimulator](https://github.com/sigmaSd/Stimulator)
[Share](https://github.com/flathub/io.github.sigmasd.share)

Here is the python kernel

```py
from ipykernel.kernelbase import Kernel

class EchoKernel(Kernel):
    implementation = 'Echo'
    implementation_version = '1.0'
    language = 'no-op'
    language_version = '0.1'
    language_info = {
        'name': 'Any text',
        'mimetype': 'text/plain',
        'file_extension': '.txt',
    }
    banner = "Echo kernel - as useful as a parrot"

    def do_execute(self, code, silent, store_history=True, user_expressions=None,
                   allow_stdin=False):
        if not silent:
            stream_content = {'name': 'stdout', 'text': code}
            self.send_response(self.iopub_socket, 'stream', stream_content)

        return {'status': 'ok',
                # The base class increments the execution count
                'execution_count': self.execution_count,
                'payload': [],
                'user_expressions': {},
               }

if __name__ == '__main__':
    from ipykernel.kernelapp import IPKernelApp
    IPKernelApp.launch_instance(kernel_class=EchoKernel)
```

Here is a start at porting (file is called a.ts)

```ts
#!/usr/bin/env -S deno run --allow-all --unstable-ffi
import { NamedArgument, PyObject, python } from "jsr:@denosaurs/python";

const m = python.runModule(`
from ipykernel.kernelbase import Kernel

class EchoKernel(Kernel):
  implementation = 'Echo'
  implementation_version = '1.0'
  language = 'no-op'
  language_version = '0.1'
  language_info = {
      'name': 'Any text',
      'mimetype': 'text/plain',
      'file_extension': '.txt',
  }
  banner = "Echo kernel - as useful as a parrot"
`);

// NOTE: this also modifies m.EchoKernel
const kernel = PyObject.from(m.EchoKernel);
kernel.setAttr(
    "do_execute",
    python.callback(() => {
        //TODO: implement this
        return {
            status: "ok",
            execution_count: 0,
            payload: [],
            user_expressions: {},
        };
    }),
);

if (import.meta.main) {
    const IPKernelApp = python.import("ipykernel.kernelapp").IPKernelApp;
    IPKernelApp.launch_instance(new NamedArgument("kernel_class", kernel));
}
```

Ok wasn't that hard, `chmod +x ./a.ts && ./a.ts`

```
NOTE: When using the `ipython kernel` entry point, Ctrl-C will not work.

To exit, you will have to explicitly quit this process, by either sending
"quit" from a client, or using Ctrl-\ in UNIX-like environments.

To read more about this, see https://github.com/ipython/ipython/issues/2049


To connect another client to this kernel, use:
    --existing kernel-15074.json
fish: Job 1, 'deno run -A a.ts' terminated by signal SIGSEGV (Address boundary error)
```

Hmm, it worked but then segfaulted, so gdb to the rescue

```
gdb --args deno run -A --unstable-ffi a.ts
```

```
(gdb) r

Thread 1 "deno" received sig``nal SIGSEGV, Segmentation fault.
0x00007ffff7e1dfb0 in __strncmp_sse42 () from /lib64/libc.so.6
```

Ok we're comparing something, lets check what it is, arguments are passed in
linux x86 in rdi then rsi

```
info registers
```

```
rsi            0x55555c25b900      93825106557184
rdi            0x5555              21845
```

`rsi` seems like a valid pointer, but `rdi` is definitely not, lets just check
`rsi` first and try to print it as a cstring

```
(gdb) x/s $rsi
0x55555c25b900: "JSCallback:anonymous"
```

Where are we doing this?

```
(gdb) bt

#0  0x00007ffff7e1dfb0 in __strncmp_sse42 () from /lib64/libc.so.6
#1  0x00007ffff4bf79f1 in find_signature
```

Ok so whats `find_signature`, lets check [cpython](https://github.com/python/cpython/blob/69c68de43aef03dd52fabd21f99cb3b0f9329201/Objects/typeobject.c#L664)

```py
/*
 * finds the beginning of the docstring's introspection signature.
 * if present, returns a pointer pointing to the first '('.
 * otherwise returns NULL.
 *
 * doesn't guarantee that the signature is valid, only that it
 * has a valid prefix.  (the signature must also pass skip_signature.)
 */
static const char *
find_signature(const char *name, const char *doc)
```

We're getting an invalid pointer for doc.

Lets look at `deno-python` to see how we're creating `name`, and `doc`. `doc`
is created [here](https://github.com/denosaurs/deno_python/blob/8bd35566b07a43746b7abd8cd1cc7730abe2b4bd/src/python.ts#L473)

```ts
const pyMethodDef = new Uint8Array(8 + 8 + 4 + 8);
const view = new DataView(pyMethodDef.buffer);
const LE =
  new Uint8Array(new Uint32Array([0x12345678]).buffer)[0] !== 0x7;
const nameBuf = new TextEncoder().encode(
  "JSCallback:" + (v.callback.name || "anonymous") + "\0",
);
view.setBigUint64(
  0,
  BigInt(Deno.UnsafePointer.value(Deno.UnsafePointer.of(nameBuf)!)),
  LE,
);
view.setBigUint64(
  8,
  BigInt(Deno.UnsafePointer.value(v.unsafe.pointer)),
  LE,
);
view.setInt32(16, 0x1 | 0x2, LE);
view.setBigUint64(
  20,
  BigInt(Deno.UnsafePointer.value(Deno.UnsafePointer.of(nameBuf)!)),
  LE,
);
const fn = py.PyCFunction_NewEx(
  pyMet hodDef,
  PyObject.from(null).handle,
  null,
);
```

We're suspecting that something is wrong with pyMethodDef buffer creation.
Looking at the [docs](https://docs.python.org/3/c-api/structures.html#c.PyMethodDef) the fields seems
correct to me

```
const char *ml_name -> 8 bytes
PyCFunction ml_meth -> 8 bytes
int ml_flags -> 4 bytes 
const char *ml_doc -> 8bytes
```

The bug is there though, can you spot it .... After I asked around (deno
discord have a couple of ffi magicians there) I have my answer:

```
from AapoAlas
    Yeah, the last pointer is not correctly aligned. Pointers should be 8 byte aligned (regardless of architecture), but it's at byte index 20: 20/8 does not an integer make.
    So 24 is the correct place for it
```

The 4th field is a pointer so it needs to be 8 byte aligned, but since the 3rd
field is only 4 bytes, there are 4 bytes of padding that are automatically
inserted

The fix turns out to be simple [https://github.com/denosaurs/deno_python/pull/65/files](https://github.com/denosaurs/deno_python/pull/65/files)

```diff
diff --git a/src/python.ts b/src/python.ts
index e09b821..9c41ea1 100644
--- a/src/python.ts
+++ b/src/python.ts
@@ -452,7 +452,9 @@ export class PyObject {
           }
           return new PyObject(list);
         } else if (v instanceof Callback) {
-          const pyMethodDef = new Uint8Array(8 + 8 + 4 + 8);
+          // https://docs.python.org/3/c-api/structures.html#c.PyMethodDef
+          // there are extra 4 bytes of padding after ml_flags field
+          const pyMethodDef = new Uint8Array(8 + 8 + 4 + 4 + 8);
           const view = new DataView(pyMethodDef.buffer);
           const LE =
             new Uint8Array(new Uint32Array([0x12345678]).buffer)[0] !== 0x7;
@@ -471,7 +473,7 @@ export class PyObject {
           );
           view.setInt32(16, 0x1 | 0x2, LE);
           view.setBigUint64(
-            20,
+            24,
             BigInt(Deno.UnsafePointer.value(Deno.UnsafePointer.of(nameBuf)!)),
             LE,
           );
```

Running the kernel, it doesn't segfault anymore, but unfortunately it just
exits.

Debugging that is another part of the story, in the meantime you can jump to the
pr where I fixed it [https://github.com/denosaurs/deno_python/pull/67](https://github.com/denosaurs/deno_python/pull/67)
[https://github.com/denosaurs/deno_python/pull/68](https://github.com/denosaurs/deno_python/pull/68)
