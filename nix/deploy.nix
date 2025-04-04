{
  writeShellScriptBin,
  website,
  lib,
  wrangler,
}:
writeShellScriptBin "deploy" ''
  ${lib.getExe wrangler} pages deploy --project-name jeffasnet ${website}
''
