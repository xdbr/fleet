{inputs, ...}: let
  set-report-path = hostName: ../../hosts/${hostName}/facter.json;
in {
  fleet.facter = {host, ...}: {
    nixos = {
      imports = [inputs.facter.nixosModules.facter];
      facter.reportPath = set-report-path host.name;
    };
  };

  flake-file.inputs = {
    facter = {
      url = "github:nix-community/nixos-facter-modules";
    };
  };
}
