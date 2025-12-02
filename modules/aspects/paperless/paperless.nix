{den, ...}: {
  den.aspects.barbara-bar = {
    OS,
    host,
    ...
  }: {
    nixos = {
      #   pkgs,
      #   lib,
      #   config,
      #   ...
      # }: {
      imports = [./_scanity-docker-compose.nix];

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
