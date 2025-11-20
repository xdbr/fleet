# This repo was generated with github:vic/flake-file#dendritic template.
# Run `nix run .#write-flake` after changing any input.
#
# Inputs can be placed in any module, the best practice is to have them
# as close as possible to their actual usage.
# See: https://vic.github.io/dendrix/Dendritic.html#minimal-and-focused-flakenix
#
# For our template, we enable home-manager and nix-darwin by default, but
# you are free to remove them if not being used by you.
{inputs, ...}: {
  flake-file.inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
