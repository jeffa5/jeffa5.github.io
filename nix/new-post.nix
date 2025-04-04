{writeShellScriptBin}:
writeShellScriptBin "new-post" ''
  path="content/blog/$(date +'%y-%m-%d')-$1"
  mkdir $path
  touch $path/index.md
  echo "Created post at $path"
''
