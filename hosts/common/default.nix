{ config, pkgs, ... }:
{
  imports = [
    ./localization.nix
    ./users.nix
    ./network.nix
  ];
}