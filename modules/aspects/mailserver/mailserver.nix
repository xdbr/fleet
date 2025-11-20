{inputs, ...}: {
  den.aspects.mailserver = {host, ...}: {
    nixos = {config, ...}: {
      imports = [inputs.simple-nixos-mailserver.nixosModule];
      mailserver = {
        enable = true;
        stateVersion = 3;
        # debug = true;

        fqdn = "mail.barbara.bar";
        domains = ["barbara.bar"];

        loginAccounts = {
          "dbr@barbara.bar" = {
            hashedPasswordFile = config.sops.secrets."mail.barbara.bar/dbr/passwordHashed".path; # mkpasswd -sm bcrypt
            aliases = ["postmaster@barbara.bar" "gitea@git.barbara.bar"];
          };
          # "user2@barbara.bar" = { ... };
        };

        certificateScheme = "acme-nginx";
      };

      sops.secrets."mail.barbara.bar/dbr/password" = {};
      sops.secrets."mail.barbara.bar/dbr/passwordHashed" = {};
    };
  };

  flake-file.inputs = {
    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master"; # nixos-25.05
    };
  };
}
