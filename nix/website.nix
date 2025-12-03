{
  stdenvNoCC,
  python3,
  lowdown,
}:
stdenvNoCC.mkDerivation {
  name = "website";
  src = ./..;
  nativeBuildInputs = [lowdown python3];
  buildPhase = ''
    make
  '';
  installPhase = ''
    mv public $out
  '';
}
