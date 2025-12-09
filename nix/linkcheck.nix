{
  lib,
  runCommand,
  website,
  lychee,
}:
runCommand "linkcheck" {} ''
  mkdir $out
  ${lib.getExe lychee} --offline --index-files "" --include-fragments ${website} | tee $out/out
''
