{
  den.default.nixos = {
    networking.firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        22
        80
        443
      ];
    };
  };
}
