{
  den,
  __findFile,
  lib,
  ...
}: {
  flake.inspector = den.aspects.barbara-bar;
  den.aspects.barbara-bar = {
    includes = [
      <bootloader/grub>
      <disko/disk-profile/ext4>
      <hetzner/qemu/kernel-modules>
      <fleet/facter>
      <fleet/sops>
      # <fleet/mailserver>
      den.aspects.mailserver
    ];

    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.hello];
      networking = {
        hostName = lib.mkForce "barbara";
        domain = lib.mkForce "barbara.bar";
        fqdn = lib.mkForce "barbara.bar";
      };
    };

    homeManager.programs.direnv.enable = true;
  };
}
