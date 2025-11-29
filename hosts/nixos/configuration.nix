{
  quadlet-nix,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
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

    virtualisation.quadlet.containers = {
      nginx = {
        autoStart = true;
        serviceConfig = {
          RestartSec = "10";
          Restart = "always";
        };
        containerConfig = {
          image = "docker.io/nginxinc/nginx-unprivileged:latest";
          publishPorts = [ "8080:8080" ];
          userns = "keep-id";
        };
      };

      jellyfin = {
        autoStart = true;
        serviceConfig = {
          RestartSec = "10";
          Restart = "always";
        };
        containerConfig = {
          image = "docker.io/jellyfin/jellyfin:latest";
          publishPorts = [ "8096:8096" ];
          userns = "keep-id";
          volumes = [
            "jellyfin-config:/config:Z"
            "jellyfin-cache:/cache:Z"
            "jellyfin-media:/media:Z"
          ];
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 8096 ];

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
