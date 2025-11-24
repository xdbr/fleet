{
  den.default.nixos = {
    networking.firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        22 # endlessh-go
        25 # mx
        80 # http
        422 # ssh
        443 # ssl
        465 # smtp
        993 # imap
      ];
    };
  };
}
