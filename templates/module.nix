{ config, pkgs, lib, ... }:

# TODO: Replace "module-name"
# TODO: Setup or Remove Autostart Option
# TODO: Set "Package-Name"

{
  options.module-name = {
    enable = {
      type = lib.types.bool;
      default = false;
      description = "Enable module-name.";
    };
    autostart = {
      type = lib.types.bool;
      default = false;
      description = "Enable App to autostart on login.";
    };
  };

  config = lib.mkIf config.module-name.autostart {

    module-name.enable = true; 

    # TODO: Setup for this app, example for Discord
    systemd.user.services.discord = {
      description = "Discord";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.vesktop}/opt/discord/discord";
        Restart = "on-failure";
      };
    };
  }

  # TODO: Set Name
  lib.mkIf config.module-name.enable {
    home.packages = [
      pkgs.Package-Name
    ];
  };
}