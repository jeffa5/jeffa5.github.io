{
  lib,
  writeShellScriptBin,
  website,
  lychee,
}:
writeShellScriptBin "linkcheck" ''
  ${lib.getExe lychee} --offline ${website}
''
