{
  writeShellScriptBin,
  nodePackages,
}:
writeShellScriptBin "format" ''
  ${nodePackages.js-beautify}/bin/js-beautify **/*.html **/*.css
''
