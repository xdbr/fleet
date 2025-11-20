{
  den,
  __findFile,
  ...
}: {
  den.aspects.dbr = {
    includes = [
      <den/define-user>
      <den/primary-user> # dbr is admin always.
      (<den/user-shell> "zsh")
    ];

    nixos = {pkgs, ...}: {};

    # <user>.provides.<host>, via eg/routes.nix
    # provides.barbara-bar = {host, ...}: {
    #   nixos.programs.nh.enable = host.name == "barbara-bar";
    # };
  };

  # This is a context-aware aspect, that emits configurations
  # **anytime** at least the `user` data is in context.
  # read more at https://vic.github.io/den/context-aware.html
  # den.aspects.dbr = {user, ...}: {
  #   nixos.users.users.${user.userName}.description = "dbr";
  # };

  # den.aspects.setHost = {host, ...}: {
  #   networking.hostName = host.hostName;
  # };
}
