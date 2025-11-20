{den ? den, ...}: {
  den.aspects.dbr.nixos = {
    services.openssh.settings.AllowUsers = ["dbr"];
    security = {
      sudo = {
        wheelNeedsPassword = false;
        # extraRules = [
        #   {
        #     users = ["dbr"];
        #     commands = [
        #       {command = "/nix/store/*-activatable-nixos-system-*/activate-rs";}
        #       {command = "/run/current-system/sw/bin/rm /tmp/deploy-rs-canary-*";}
        #     ];
        #   }
        # ];
      };
      pam = {
        sshAgentAuth.enable = true;
        services.sudo.sshAgentAuth = true;
      };
    };
  };
}
