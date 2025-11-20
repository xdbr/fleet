{den ? den, ...}: {
  den.aspects.dbr.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      ncdu
      neofetch
      nixd
      alejandra
      btop
      htop
      nodejs_24
      deno
      httpie
      fswatch
      nix-direnv
    ];
  };
}
