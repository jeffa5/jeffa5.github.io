{writeShellScriptBin}:
writeShellScriptBin "new-post" ''
  path="content/blog/$(date +'%Y-%m-%d')-$1"
  mkdir "$path"
  post="$path/index.md"
  touch "$post"

  echo "# $1" > "$post"

  echo "Created post at $post"
''
