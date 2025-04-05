{
  pkgs,
  config,
  lib,
  ...
}: {
  users.mutableUsers = false;

  users.users.fabian = {
      isNormalUser = true;
      extraGroups = ifTheyExist [ 
        "networkmanager"
        "wheel"
        "libvirtd" 
      ];
      packages = [pkgs.home-manager];
  };

  home-manager.users.fabian = import ../../../../home/fabian/${config.networking.hostName}.nix;
}