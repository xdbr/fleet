{den, ...}: {
  den.default.nixos = {
    security.acme = {
      acceptTerms = true;
      defaults.email = "daniel@codeedition.de";
    };
  };
}
