{
  den.default.nixos = {
    nix.settings = {
      trusted-users = ["dbr" "@wheel"];
      experimental-features = ["nix-command" "flakes"];
    };
  };
}
