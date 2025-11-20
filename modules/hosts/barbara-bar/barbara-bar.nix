{
  den,
  __findFile,
  lib,
  ...
}: {
  # fleet.barbara-bar = {
  den.aspects.barbara-bar = {
    includes = [
      <bootloader/grub>
      <disko/disk-profile/ext4>
      <hetzner/qemu/kernel-modules>
      <fleet/facter>
      <fleet/sops>
      # <fleet-server/stdenv>
    ];

    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.hello];
    };

    provides.dbr = {user, ...}: {
      # includes = [
      #   # <den/define-user>
      #   # <den/primary-user> # alice is admin always.
      # ];
      homeManager.programs.helix.enable = user.name == "dbr";
    };
    homeManager.programs.direnv.enable = true;
  };
}
