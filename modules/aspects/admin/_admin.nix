{
  den,
  __findFile ? __findFile,
  ...
}: {
  den.provides.admin = {
    # includes = [
    #   <den/primary-user>
    # ];

    nixos = {
      pkgs,
      lib,
      ...
    }: {
      users.users.root = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        shell = lib.mkDefault pkgs.fish;
        packages = [pkgs.htop];
        openssh.authorizedKeys.keys = [
          ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxB6GdMYcQgxo5jcibOUM4tGRBjLjuKLaMcWki6sdxO/JllbBo8tT4tWqJONRK/K3FzdF6y0RfrSVH3iIVXJ+s+TU7W1BSnZtBaAZtrZruwzn5yUkZpepQ6XtbsY1+mb/BRLitvrDsYlRRmeJxypO8bQSU9sJEuKRFR8LWl+b3x8+SEjd8b8C0/q7n5FZbdGI9SQ3f/xw7OvukXIGCRCjXqDRKtiWG/1CICNrbxinLbgFHfANTBfxwMITnwt6O0vsMM2ZhOThMlRbjrIsOUFppgoABLQSynMJvMrLKiqHaEQq5+ph0+xWfaAZaU1hgjVhNROojySvk6UC6+qahAPCO70hZpXAZup+NI2z1HDCs9Zw44GuHW5m+8eKv0QfZFYOaL7ic+wlAXehGN53G9Pkpr/LSVD5F4Ogkb6poniF9tQf9cfMfZJhMyVxkHjFvweUHgDrEmMzGZc5SLXp6Tw+DigWocCDCarnYOzpaMII1ctD5ApjU0ISJm9RPddckj2WXXeKO7Miie+Q5+gxCprD8LwaNAP7DotbvBbCDIKsvfz8u53r+yQz1hUfRKJ4U5mggE7zskzeF42wnHot3H2O16d4u4rYzfYSYR9631+PJ4ll+wUTrqKfqsar/Pu7u3+1ER/tSkdj6awI0z7OS9HDQtXS5ZqagyQwKMIKKOaSo/w==''
        ];
      };
    };
  };
}
