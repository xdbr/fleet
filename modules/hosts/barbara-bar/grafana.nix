{den, ...}: {
  den.aspects.barbara-bar = {
    OS,
    host,
    ...
  }: {
    nixos = {config, ...}: {
      services.grafana = {
        enable = true;
        settings = {
          server = {
            domain = "grafana.vip.barbara.bar";
            http_port = 2342;
            http_addr = "10.0.0.1";
            # Do not expose without VPN
            enforce_domain = false;
          };
        };
        provision = {
          enable = true;
          datasources.settings.datasources = [
            {
              name = "Prometheus";
              type = "prometheus";
              access = "proxy";
              url = "http://127.0.0.1:${toString config.services.prometheus.port}";
            }
          ];
        };
      };

      services.dnsmasq = {
        enable = true;

        settings = {
          # Listen *only* on the VPN interface so it's not exposed publicly
          interface = "wg0";
          listen-address = ["10.0.0.1" "127.0.0.1"];
          bind-interfaces = true;

          # We are authoritative for the internal subdomain,
          # do not advertise our private entries publicly
          local = "/vip.barbara.bar/";

          # Define internal host(s)
          address = [
            "/vip.barbara.bar/10.0.0.1" # This is a wildcard already for all sub-domains
            # "/grafana.vip.barbara.bar/10.0.0.1" # so this is redundant
          ];

          domain-needed = true; # do not forward single word names without a dot, e.g. localhost, or printer
          bogus-priv = true;
          log-queries = true;
        };
      };

      networking.firewall = {
        enable = true;
        allowedUDPPorts = [51820]; # WireGuard itself
        # dnsmasq on wg0; restrict with interface if needed
        interfaces.wg0 = {
          allowedUDPPorts = [53];
          allowedTCPPorts = [53];
        };

        # Optionally harden further with extraCommands
        extraCommands = ''
          # Drop DNS on non-wg0 interfaces
          iptables -A INPUT ! -i wg0 -p udp --dport 53 -j DROP
          iptables -A INPUT ! -i wg0 -p tcp --dport 53 -j DROP
        '';
      };

      # nginx reverse proxy
      services.nginx = {
        virtualHosts.${config.services.grafana.settings.server.domain} = {
          serverName = config.services.grafana.settings.server.domain;
          enableACME = true;
          forceSSL = true;
          listenAddresses = ["10.0.0.1"];

          extraConfig = ''
            # allow only VPN clients
            allow 10.0.0.0/24;
            deny all;
          '';

          locations."/" = {
            # proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
            proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
            proxyWebsockets = true;
          };
        };
      };

      services.endlessh-go = {
        enable = true;
        port = 22;
        prometheus = {
          enable = true;
          # port = 9119;
        };
      };

      services.prometheus = {
        enable = true;
        port = 9001;
        globalConfig.scrape_interval = "1m";
        exporters = {
          node = {
            enable = true;
            enabledCollectors = ["systemd"];
            # extraFlags = ["--collector.ethtool" "--collector.softirqs" "--collector.tcpstat" "--collector.wifi"];
            port = 9002;
          };
        };
        scrapeConfigs = [
          {
            job_name = "endlessh-go";
            static_configs = [{targets = ["127.0.0.1:${toString config.services.endlessh-go.prometheus.port}"];}];
          }
          {
            job_name = "barbara.bar";
            static_configs = [
              {
                targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];
              }
            ];
          }
        ];
      };
    };
  };
}
