{
  description = "Jeffas' blog";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {inherit system;};

        website = pkgs.stdenvNoCC.mkDerivation {
          name = "website";
          src = ./.;
          nativeBuildInputs = [pkgs.zola];
          buildPhase = ''
            zola build
          '';
          installPhase = ''
            mv public $out
          '';
        };

        deploy = pkgs.writeShellScriptBin "deploy" ''
          ${pkgs.lib.getExe pkgs.wrangler} pages deploy --project-name jeffasnet ${website}
        '';

        format = pkgs.writeShellScriptBin "format" ''
          ${pkgs.nodePackages.js-beautify}/bin/js-beautify **/*.html **/*.css
        '';
      in {
        packages = {inherit format website deploy;};

        formatter = pkgs.alejandra;

        devShell = pkgs.mkShell {
          packages = [
            pkgs.zola
            pkgs.nodePackages.js-beautify
          ];
        };
      }
    );
}
