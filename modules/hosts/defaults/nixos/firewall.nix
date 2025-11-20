{
  den.default.nixos = {
    networking.firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        22
        25 # mx
        80
        443
        465 # smtp
        993 # imap
      ];
    };
  };
}
