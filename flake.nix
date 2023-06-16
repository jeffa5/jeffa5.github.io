{
  description = "Jeffas' blog";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
      in {
        packages.format = pkgs.writeShellScriptBin "format" ''
          ${pkgs.nodePackages.js-beautify}/bin/js-beautify **/*.html **/*.css
        '';

        formatter = pkgs.alejandra;

        devShell = pkgs.mkShell {
          packages = with pkgs; [
            zola
            nodePackages.js-beautify
          ];
        };
      }
    );
}
