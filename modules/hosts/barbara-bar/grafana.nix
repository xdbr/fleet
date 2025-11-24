{den, ...}: {
  den.aspects.barbara-bar = {
    OS,
    host,
    ...
  }: {
    nixos = {config, ...}: {
      # environment.etc."grafana/dashboards" = {
      #   source = ./dashboards;
      #   user = "grafana";
      #   group = "grafana";
      # };

      services.grafana = {
        enable = true;
        settings = {
          server = {
            domain = "grafana.barbara.bar";
            http_port = 2342;
          };
        };
        # addr = "127.0.0.1";
        provision = {
          enable = true;
          # dashboards.settings.providers = [
          #   {
          #     # this tells grafana to look at the path for dashboards
          #     options.path = "/etc/grafana/dashboards";
          #   }
          # ];
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

      # nginx reverse proxy
      services.nginx = {
        virtualHosts.${config.services.grafana.settings.server.domain} = {
          enableACME = true;
          forceSSL = true;
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
        globalConfig.scrape_interval = "10s"; # "1m"
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
            static_configs = [
              {
                targets = ["127.0.0.1:${toString config.services.endlessh-go.prometheus.port}"];
              }
            ];
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
