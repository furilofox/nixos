{
  pkgs,
  config,
  lib,
  ...
}: let

  ssh = "${pkgs.openssh}/bin/ssh";

in {
  programs.git = {
    enable = true;
    
    userName = "Furilo";
    userEmail = lib.mkDefault "late.book0382@furilofox.dev";
    extraConfig = {
      init.defaultBranch = "main";
      # Automatically track remote branch
      push.autoSetupRemote = true;
    };
    lfs.enable = true;
    ignores = [
      ".venv"
    ];
  };
}