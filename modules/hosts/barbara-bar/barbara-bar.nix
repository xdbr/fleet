{
  den,
  __findFile,
  lib,
  ...
}: {
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
      networking = {
        hostName = "barbarabar";
        domain = "barbara.bar";
      };
    };

    homeManager.programs.direnv.enable = true;
  };
}
