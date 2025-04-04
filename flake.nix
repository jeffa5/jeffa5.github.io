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
        packages = pkgs.callPackage ./nix {};
      in {
        packages = packages;

        formatter = pkgs.alejandra;

        devShell = pkgs.mkShell {
          packages = [
            pkgs.zola
            pkgs.nodePackages.js-beautify
            packages.new-post
          ];
        };
      }
    );
}
