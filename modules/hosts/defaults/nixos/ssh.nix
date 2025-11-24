{
  den.default.nixos = {
    services.openssh = {
      enable = true;
      ports = [422];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false; # Recommended for enhanced security
        KbdInteractiveAuthentication = false;
        PubkeyAuthentication = true;
      };
    };
  };
}
