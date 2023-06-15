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
        jekyll_env = pkgs.bundlerEnv {
          name = "blog";
          ruby = pkgs.ruby;
          gemfile = ./Gemfile;
          lockfile = ./Gemfile.lock;
          gemset = ./gemset.nix;
        };
      in {
        devShell = pkgs.mkShell {
          packages = [
            jekyll_env
            pkgs.zola
          ];
        };
      }
    );
}
