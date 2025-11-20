{
  den.default.nixos = {
    services.openssh = {
      enable = true;
      ports = [22];
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = false; # Recommended for enhanced security
        PubkeyAuthentication = true;
      };
    };
  };
}
