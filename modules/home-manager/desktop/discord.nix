{ config, pkgs, lib, ... }:

{
  options.vesktop = {
    enable = {
      type = lib.types.bool;
      default = false;
      description = "Enable Vesktop installation and configuration.";
    };
    autostart = {
      type = lib.types.bool;
      default = false;
      description = "Enable Vesktop to autostart on login.";
    };
  };

  config = lib.mkIf config.vesktop.autostart {
    vesktop.enable = true;

    systemd.user.services.vesktop = {
      description = "Vesktop";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "vesktop %U";
        Restart = "on-failure";
      };
    };
  }

  lib.mkIf config.vesktop.enable {
    home.packages = [
      pkgs.vesktop
    ];
  };
}