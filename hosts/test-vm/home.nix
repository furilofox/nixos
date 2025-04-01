{ config, pkgs, inputs, outputs, ... }:
{
  home.packages = with pkgs; [
    inputs.home-manager.legacyPackages.${pkgs.system}.hm.dag.brave
  ];

  services.brave.enable = true;

  services.discord = {
    enable = true;
    autostart = true;
  };
}