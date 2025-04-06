{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    ./hardware-configuration.nix

    ../common/global/default.nix
    ../common/users/fabian.nix

    ../common/optional/systemd-boot.nix
    ../common/optional/gnome.nix
    ../common/optional/opengl.nix
    ../common/optional/nvidia.nix

    ../common/optional/pipewire.nix
    ../common/optional/printing.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };
  
  # ============================================== #
  # Steam / Gaming
  # ============================================== #
  
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };
  
  programs.gamemode.enable = true;

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
    # Force Wayland for Chromium based applications
    NIXOS_OZONE_WL = "1";
    # Force Wayland for vscode
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    # Force Wayland for firefox
    MOZ_ENABLE_WAYLAND=1;
  };
  
  # hardware.logitech.wireless.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    mangohud			# Game Hardware stats
    protonup 			# "protonup" in terminal to download proton-ge
    lutris 			# great game launcher
    heroic 			# good for epicgames
    bottles			# windows app container
    vesktop			# discord + vencord
    _1password-gui		# 1Password Desktop
    mission-center		# Task / System Monitor
    gnome-extension-manager
    vscode
    brave
    gparted
    easyeffects
    nextcloud-client
    telegram-desktop
    git
    obsidian

    virt-manager
    virt-viewer

    spice
    spice-gtk # Might be needed for client-side rendering in Virt Manager
    libvirt # Ensure libvirt is installed
    qemu # Ensure QEMU is installed

    prismlauncher

    # solaar # needs sudo to see mouse, idk what the actual buttons are called
    # gnomeExtensions.solaar-extension
  ];


  programs.dconf.enable = true;
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  users.groups.libvirtd.members = ["fabian"];
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;  # enable copy and paste between host and guest

  networking = {
    hostName = "fabian-desktop";
    networkmanager = {
      enable = true;
    };
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
