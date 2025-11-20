{
  den.aspects.hetzner._.qemu._.kernel-modules = {
    # Enables non-free firmware on devices not recognized by `nixos-generate-config`.
    nixos = {lib, ...}: {
      hardware.enableRedistributableFirmware = lib.mkDefault true;

      boot.initrd.availableKernelModules = [
        "virtio_net"
        "virtio_pci"
        "virtio_mmio"
        "virtio_blk"
        "virtio_scsi"
        "9p"
        "9pnet_virtio"
      ];

      boot.initrd.kernelModules = [
        "virtio_balloon"
        "virtio_console"
        "virtio_rng"
        "virtio_gpu"
      ];
    };
  };
}
