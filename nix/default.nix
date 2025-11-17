{pkgs}: let
  callPackage = pkgs.lib.callPackageWith (pkgs // packages);
  packages = {
    website = callPackage ./website.nix {};
    deploy = callPackage ./deploy.nix {};
    format = callPackage ./format.nix {};
    linkcheck = callPackage ./linkcheck.nix {};
    new-post = callPackage ./new-post.nix {};
  };
in
  packages
