{den, ...}: {
  den.aspects.barbara-bar = {
    OS,
    host,
    ...
  }: {
    nixos = {config, ...}: {
      imports = [./_scanity-docker-compose.nix];

      sops.secrets."scanity-paperless-gpt/CORRESPONDENT_BLACK_LIST" = {};
      sops.secrets."scanity-paperless-gpt/PAPERLESS_API_TOKEN" = {};

      sops.templates."paperless-gpt.secrets".content = ''
        CORRESPONDENT_BLACK_LIST=${config.sops.placeholder."scanity-paperless-gpt/CORRESPONDENT_BLACK_LIST"}
        PAPERLESS_API_TOKEN=${config.sops.placeholder."scanity-paperless-gpt/PAPERLESS_API_TOKEN"}
      '';

      virtualisation.oci-containers.containers."scanity-paperless-gpt".environmentFiles = [
        config.sops.templates."paperless-gpt.secrets".path
      ];

      services.nginx.virtualHosts = {
        "dbr.paperless.barbara.bar" = {
          enableACME = true;
          forceSSL = true;
          listenAddresses = ["10.0.0.1"];
          locations."/" = {
            proxyPass = "http://127.0.0.1:8000";
            proxyWebsockets = true;
            extraConfig = ''
              default_type text/html;
              proxy_cookie_path off;
            '';
          };
        };

        "dbr.paperless-gpt.barbara.bar" = {
          enableACME = true;
          forceSSL = true;
          listenAddresses = ["10.0.0.1"];
          locations."/" = {
            proxyPass = "http://127.0.0.1:8080";
            proxyWebsockets = true;
          };
        };
      };
    };
  };
}
