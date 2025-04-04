{
  stdenvNoCC,
  zola,
}:
stdenvNoCC.mkDerivation {
  name = "website";
  src = ./..;
  nativeBuildInputs = [zola];
  buildPhase = ''
    zola build
  '';
  installPhase = ''
    mv public $out
  '';
}
