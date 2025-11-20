{
  inputs,
  self,
  ...
}: {
  flake.deploy.nodes = {
    barbara-bar = {
      sshUser = "dbr";
      hostname = "46.62.229.209";

      profiles = {
        system = {
          user = "dbr";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.barbara-bar;
        };
        dbr = {
          user = "dbr";
          # path = inputs.deploy-rs.lib.x86_64-linux.activate.home-manager self.homeConfigurations."dbr@barbara-bar";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.home-manager self.homeConfigurations.dbr;
        };
      };
    };

    okidoki = {
      sshUser = "root";
      hostname = "135.181.254.121";

      profiles = {
        system = {
          user = "root";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.okidoki;
        };
        dbr = {
          user = "dbr";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.home-manager self.homeConfigurations.dbr;
        };
      };
    };
  };
}
