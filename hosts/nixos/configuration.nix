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

  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 53;
  };

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

      adguard = {
        autoStart = true;
        serviceConfig = {
          RestartSec = "10";
          Restart = "always";
        };
        containerConfig = {
          image = "docker.io/adguard/adguardhome:latest";
          publishPorts = [
            "53:53/tcp"
            "53:53/udp"
            "3000:3000/tcp"
            "8080:80/tcp"
          ];
          volumes = [
            "adguard-work:/opt/adguardhome/work:Z"
            "adguard-conf:/opt/adguardhome/conf:Z"
          ];
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    53
    3000
    8080
    8096
  ];
  networking.firewall.allowedUDPPorts = [ 53 ];

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
