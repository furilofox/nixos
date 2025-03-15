{ config, pkgs, lib, ... }:

# TODO: Replace ${moduleName}
# TODO: Replace ${packageName}

{
  ${moduleName} = {
    enable = {
      type = lib.types.bool;
      default = false;
      description = "Enable ${packageName} installation and configuration.";
    };
    autostart = {
      type = lib.types.bool;
      default = false;
      description = "Enable ${packageName} to autostart on login.";
    };
  };

  config = lib.mkIf config.${moduleName}.autostart {
    # If autostart is enabled, also enable the package
    ${moduleName}.enable = true;

    systemd.user.services.${packageName} = {
      description = "${packageName}";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.${packageName}}/bin/${packageName}"; #TODO: Adjust path if needed
        Restart = "on-failure";
      };
    };
  }
  lib.mkIf config.${moduleName}.enable {
    home.packages = [
      pkgs.${packageName}
    ];
  };
}