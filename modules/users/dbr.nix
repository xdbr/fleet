{
  den,
  eg,
  ...
}: {
  den.aspects.dbr = {
    includes = let
      # deadnix: skip # not required, showcasing angle-brackets syntax.
      inherit (den.lib) __findFile;

      customEmacs.homeManager = {pkgs, ...}: {
        programs.emacs.enable = true;
        programs.emacs.package = pkgs.emacs30-nox;
      };
    in [
      # from local bindings.
      customEmacs
      # from the aspect tree, cooper example is defined bellow
      # den.aspects.cooper
      # (den.aspects.setHost "barbara-bar")
      # from the `eg` namespace.
      eg.autologin
      # den included batteries that provide common configs.
      # <den/define-user>
      # <den/primary-user> # alice is admin always.
      (<den/user-shell> "fish") # default user shell
    ];

    nixos = {pkgs, ...}: {
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
      users.users.dbr = {
        isNormalUser = true;
        packages = [pkgs.vim];
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        uid = 2000;

        openssh.authorizedKeys.keys = [
          ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOrOW2rnZO+2gdABgzmaNBp5W5RhQrfRhCM8PAXAskPp daniel@codeedition.de''
          # ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxB6GdMYcQgxo5jcibOUM4tGRBjLjuKLaMcWki6sdxO/JllbBo8tT4tWqJONRK/K3FzdF6y0RfrSVH3iIVXJ+s+TU7W1BSnZtBaAZtrZruwzn5yUkZpepQ6XtbsY1+mb/BRLitvrDsYlRRmeJxypO8bQSU9sJEuKRFR8LWl+b3x8+SEjd8b8C0/q7n5FZbdGI9SQ3f/xw7OvukXIGCRCjXqDRKtiWG/1CICNrbxinLbgFHfANTBfxwMITnwt6O0vsMM2ZhOThMlRbjrIsOUFppgoABLQSynMJvMrLKiqHaEQq5+ph0+xWfaAZaU1hgjVhNROojySvk6UC6+qahAPCO70hZpXAZup+NI2z1HDCs9Zw44GuHW5m+8eKv0QfZFYOaL7ic+wlAXehGN53G9Pkpr/LSVD5F4Ogkb6poniF9tQf9cfMfZJhMyVxkHjFvweUHgDrEmMzGZc5SLXp6Tw+DigWocCDCarnYOzpaMII1ctD5ApjU0ISJm9RPddckj2WXXeKO7Miie+Q5+gxCprD8LwaNAP7DotbvBbCDIKsvfz8u53r+yQz1hUfRKJ4U5mggE7zskzeF42wnHot3H2O16d4u4rYzfYSYR9631+PJ4ll+wUTrqKfqsar/Pu7u3+1ER/tSkdj6awI0z7OS9HDQtXS5ZqagyQwKMIKKOaSo/w== daniel@codeedition.de''
        ];
      };
    };

    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.htop];
    };

    # <user>.provides.<host>, via eg/routes.nix
    provides.barbara-bar = {host, ...}: {
      nixos.programs.nh.enable = host.name == "barbara-bar";
    };
  };

  # This is a context-aware aspect, that emits configurations
  # **anytime** at least the `user` data is in context.
  # read more at https://vic.github.io/den/context-aware.html
  # den.aspects.dbr = {user, ...}: {
  #   nixos.users.users.${user.userName}.description = "dbr";
  # };

  den.aspects.setHost = {host, ...}: {
    networking.hostName = host.hostName;
  };
}
