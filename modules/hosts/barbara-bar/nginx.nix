{
  den.aspects.barbara-bar.nixos.services.nginx = {
    enable = true;
    logError = "stderr info";

    recommendedTlsSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedBrotliSettings = true;

    clientMaxBodySize = "16m";

    virtualHosts = {
      "barbara.bar" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          return = "200 '<html><body>This is barbara.bar</body></html>'";
          extraConfig = ''default_type text/html;'';
        };
      };

      "bar.barbara.bar" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          return = "200 '<html><body>This is bar.barbara.bar</body></html>'";
          extraConfig = ''default_type text/html;'';
        };
      };
    };
  };
}
