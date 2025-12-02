{den, ...}: {
  den.aspects.barbara-bar = {
    OS,
    host,
    ...
  }: {
    nixos = {
      #config, ...}: {
      networking.wireguard.interfaces = {
        wg0 = {
          privateKeyFile = "/etc/wireguard/privatekey";
          ips = ["10.0.0.1/24"];
          listenPort = 51820;
          mtu = 1328;

          peers = [
            {
              # SEA
              publicKey = "hwOjSyMTGqBwUkErEYWMsCKHPQjH2b1l0PvxZ2f8xnA=";
              # Allow a single client IP inside the VPN.
              # Matches the client's "Address = 10.0.0.2/32"
              allowedIPs = ["10.0.0.2/32"];
            }
          ];
        };
      };

      # Allow WireGuard port on firewall
      networking.firewall.allowedUDPPorts = [51820];

      # Allow traffic coming from the VPN interface itself
      networking.firewall.interfaces.wg0.allowedTCPPorts = [
        80 # nginx
        443 # if you later enable ACME/SSL
        11434
      ];
      # networking.firewall.interfaces.wg0.allowedUDPPorts = [];
    };
  };
}
