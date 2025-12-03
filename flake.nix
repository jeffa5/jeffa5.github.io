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
        packages = {
          inherit
            (packages)
            website
            deploy
            format
            linkcheck
            new-post
            ;
        };

        checks = {inherit (packages) website linkcheck;};

        formatter = pkgs.alejandra;

        devShell = pkgs.mkShell {
          packages = [
            pkgs.lowdown
            pkgs.python3
            packages.new-post
          ];
        };
      }
    );
}
