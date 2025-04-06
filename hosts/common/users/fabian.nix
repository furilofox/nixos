{
  pkgs,
  config,
  lib,
  ...
}: {
  users.users.fabian = {
      isNormalUser = true;
      extraGroups = [ 
        "networkmanager"
        "wheel"
        "libvirtd" 
      ];
      packages = [pkgs.home-manager];
  };
}