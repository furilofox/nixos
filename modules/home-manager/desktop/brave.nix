{ config, pkgs, lib, ... }:

{
  brave = {
    enable = {
      type = lib.types.bool;
      default = false;
      description = "Enable brave installation and configuration.";
    };
    autostart = {
      type = lib.types.bool;
      default = false;
      description = "Enable brave to autostart on login.";
    };
  };

  config = lib.mkIf config.brave.autostart {
    # If autostart is enabled, also enable the package
    brave.enable = true;

    systemd.user.services.brave = {
      description = "brave";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "brave %U";
        Restart = "on-failure";
      };
    };
  }
  lib.mkIf config.brave.enable {
    home.packages = [
      pkgs.brave
    ];
  };
}