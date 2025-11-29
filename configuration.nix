# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  system.stateVersion = "25.05"; # Do not edit

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";
  
  users.users.ryan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.zsh;
    home = "/home/ryan";
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];
  
  services.openssh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
}

