{ config, pkgs, lib, ... }:

{
  git = {
    enable = {
      type = lib.types.bool;
      default = false;
      description = "Enable git installation and configuration.";
    };
  };

  config = lib.mkIf config.git.enable {
    programs.git = {
        enable = true;
        userName = "Furilo";
        userEmail = "";
    }
    
  };
}