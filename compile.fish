#!/bin/fish

cd blogs

for i in (ls | rg '\.md')
    set h (echo $i | sd '..$' 'html'); markdown_py $i 1>$h;
end;

cd ..

markdown_py index.md 1>index.html
