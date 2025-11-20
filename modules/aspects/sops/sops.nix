{inputs, ...}: let
  set-secrets-path = hostName: ../../hosts/${hostName}/secrets.yaml;
in {
  fleet.sops = {host, ...}: {
    nixos = {
      imports = [inputs.sops-nix.nixosModules.sops];

      sops = {
        defaultSopsFile = set-secrets-path host.name;
        age = {
          # This will automatically import SSH keys as age keys
          sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];

          # This is using an age key that is expected to already be in the filesystem
          # sops.age.keyFile = "/var/lib/sops-nix/key.txt";
          keyFile = "/home/dbr/.config/sops/age/keys.txt";

          # This will generate a new key if the key specified above does not exist
          generateKey = true;
        };
      };
    };
  };

  flake-file.inputs = {
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
