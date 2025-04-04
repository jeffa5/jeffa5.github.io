{pkgs}: let
  packages = {
    website = callPackage ./website.nix {};
    deploy = callPackage ./deploy.nix {};
    format = callPackage ./format.nix {};
    new-post = callPackage ./new-post.nix {};
  };
  callPackage = pkgs.lib.callPackageWith (pkgs // packages);
in
  packages
