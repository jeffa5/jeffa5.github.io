{writeShellScriptBin}:
writeShellScriptBin "new-post" ''
  path="content/blog/$(date +'%Y-%m-%d')-$1"
  mkdir "$path"
  post="$path/index.md"
  touch "$post"

  echo -e "---\ntitle: \"$1\"\ndraft: true\n---\n\n" > "$post"

  echo "Created post at $post"
''
