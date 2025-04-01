{ config, pkgs, ... }:
{
  users.users = {
    fabian = {
      initialPassword = "ChangeAfterBoot";
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "libvirtd"];
    };
  };
}