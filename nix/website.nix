{
  stdenvNoCC,
  lowdown,
}:
stdenvNoCC.mkDerivation {
  name = "website";
  src = ./..;
  nativeBuildInputs = [lowdown];
  buildPhase = ''
    make
  '';
  installPhase = ''
    mv public $out
  '';
}
