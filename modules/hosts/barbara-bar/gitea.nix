{
  den.aspects.barbara-bar.nixos = {config, ...}: {
    services.nginx.virtualHosts."git.barbara.bar" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:3001/";

        # https://docs.gitea.com/administration/reverse-proxies
        # proxy_set_header Connection $http_connection;
        # proxy_set_header Upgrade $http_upgrade;
        # proxy_set_header Host $host;
        # proxy_set_header X-Real-IP $remote_addr;
        # proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        # proxy_set_header X-Forwarded-Proto $scheme;
      };
    };

    services.postgresql = {
      ensureDatabases = [config.services.gitea.user];
      ensureUsers = [
        {
          name = config.services.gitea.database.user;
          ensureDBOwnership = true;
          # ensurePermissions."DATABASE ${config.services.gitea.database.name}" = "ALL PRIVILEGES";
        }
      ];
    };

    sops.secrets."git.barbara.bar/postgres/gitea_dbpass" = {
      owner = config.services.gitea.user;
    };

    services.gitea = {
      enable = true;
      lfs.enable = true;

      appName = "barbara.bar's Gitea server";

      dump = {
        enable = false;
        # backupDir = "${config.services.nextcloud.home}/data/daniel/files";
      };

      database = {
        type = "postgres";
        # passwordFile = config.sops.secrets."website.okidoki.git.postgres.gitea_dbpass".path;
        passwordFile = config.sops.secrets."git.barbara.bar/postgres/gitea_dbpass".path;
      };

      # mailerPasswordFile = config.sops.secrets."okidoki.website.mail.dbr.password".path;
      settings = {
        service = {
          ENABLE_NOTIFY_MAIL = false;
          DISABLE_REGISTRATION = true;
        };

        log = {
          # LEVEL = "debug";
        };

        server = {
          DOMAIN = "git.barbara.bar";
          ROOT_URL = "https://git.barbara.bar";
          HTTP_PORT = 3001;
        };

        mailer = {
          ENABLED = false;
          # PROTOCOL = "dummy"; # send email to log instead

          FROM = "gitea@git.okidoki.website";

          SMTP_ADDR = "mail.okidoki.website";
          SMTP_PORT = "465";

          USER = "dbr@okidoki.website";
          # PASSWD = ''${config.sops.secrets."okidoki.website.mail.dbr.password"}''; # see above
        };
      };
    };

    services.cron = {
      enable = false;
      systemCronJobs = [
        # "*/5 * * * *      root    date >> /tmp/cron.log"
        # ''31 5 * * *    root cp -p "`ls -ltr ${config.services.gitea.dump.backupDir} | tail -1`" "${config.users.users.dbr.home}/backup/gitea"''
      ];
    };
  };
}
