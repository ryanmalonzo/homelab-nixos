{ config, pkgs, ... }:
{
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers.nginx = {
    image = "nginx:latest";
    ports = [ "8080:80" ];
  };
}
