{ ... }:
{
  home-manager.users.ryan.virtualisation.quadlet.containers.jellyfin = {
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

  networking.firewall.allowedTCPPorts = [ 8096 ];
}

