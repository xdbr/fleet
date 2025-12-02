{den, ...}: {
  den.aspects.barbara-bar = {
    OS,
    host,
    ...
  }: {
    nixos = {
      services.dnsmasq = {
        enable = true;

        settings = {
          # Listen *only* on the VPN interface so it's not exposed publicly
          interface = "wg0";
          listen-address = ["10.0.0.1" "127.0.0.1"];
          bind-interfaces = true;

          # We are authoritative for the internal subdomain,
          # do not advertise our private entries publicly
          # local = "/vip.barbara.bar/";

          # Define internal host(s)
          address = [
            "/vip.barbara.bar/10.0.0.1" # This is a wildcard already for all sub-domains
            "/paperless.barbara.bar/10.0.0.1" # This is a wildcard already for all sub-domains
            "/paperless-gpt.barbara.bar/10.0.0.1" # This is a wildcard already for all sub-domains
          ];

          domain-needed = true; # do not forward single word names without a dot, e.g. localhost, or printer
          bogus-priv = true;
          log-queries = true;
          server = [
            "9.9.9.9"
            "8.8.8.8"
            "8.8.4.4"
          ];
        };
      };
    };
  };
}
