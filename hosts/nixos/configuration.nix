{
  quadlet-nix,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./services/jellyfin.nix
    ./services/adguard.nix
  ];

  virtualisation.quadlet.enable = true;

  system.stateVersion = "25.05"; # Do not edit

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo.wheelNeedsPassword = false;

  users.users.ryan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.zsh;
    home = "/home/ryan";
    linger = true;
    autoSubUidGidRange = true;
  };

  home-manager.users.ryan = {
    imports = [ quadlet-nix.homeManagerModules.quadlet ];

    home.stateVersion = "25.05"; # Do not edit
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  services.openssh.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
}
