function grepr
    grep -inRw -E $argv[1] $argv[2] --include=\*.{c,h,cpp,hpp,py,js,ts,html} --exclude-dir={.git,__pycache__,.vscode,bin,lib,include,node_modules}
end 
