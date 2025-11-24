{
  inputs,
  self,
  ...
}: {
  flake.deploy.nodes."barbara-bar" = {
    sshUser = "dbr";
    sshOpts = ["-p" "422"];
    hostname = "46.62.229.209";
    interactiveSudo = false;
    autoRollback = true;
    remoteBuild = false;

    profiles = {
      system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.barbara-bar;
      };
      dbr = {
        user = "dbr";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.home-manager self.homeConfigurations.dbr;
      };
    };
  };
}
