{ ... }:
{
  boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 53;

  home-manager.users.ryan.virtualisation.quadlet.containers.adguard = {
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

  networking.firewall.allowedTCPPorts = [ 53 3000 8080 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}

