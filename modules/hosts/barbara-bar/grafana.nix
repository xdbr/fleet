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
            http_addr = "127.0.0.1";
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

      systemd.services.dnsmasq = {
        wants = ["sys-subsystem-net-devices-wg0.device"];
        after = ["sys-subsystem-net-devices-wg0.device"];
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

          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
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
            static_configs = [{targets = ["127.0.0.1:${toString config.services.prometheus.exporters.node.port}"];}];
          }
        ];
      };
    };
  };
}
