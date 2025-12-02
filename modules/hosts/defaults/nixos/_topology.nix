{
  self,
  inputs,
  pkgs,
  ...
}: {
  flake-file.inputs = {
    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.default.nixos = {
    imports = [
      inputs.nix-topology.nixosModules.default
    ];
    # topology = #import inputs.nix-topology {
    # inherit pkgs;
    # modules = [
    # {nixosConfigurations = self.nixosConfigurations;}
    # ];
    # };
  };
}
