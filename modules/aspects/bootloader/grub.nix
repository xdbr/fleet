{
  den.aspects.bootloader._.grub = {
    nixos = {
      boot.loader.grub = {
        # dvices will be set by disko!
        # devices = ["/dev/sda"];
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };
  };
}
