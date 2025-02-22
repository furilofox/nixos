{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      
      <home-manager/nixos>
    ];
    
  # ============================================== #
  # Bootloader
  # ============================================== #

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # ============================================== #
  # Networking
  # ============================================== #
  
  # networking = {
  #   hostName = "fabian-desktop";
  #   networkmanager = {
  #     enable = true;
  #   };
  #   nameservers = [ "1.1.1.1" "8.8.8.8" ];
  # };
  
  # ============================================== #
  # Localization
  # ============================================== #

  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
  
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";
  
  # ============================================== #
  # Display
  # ============================================== #

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  # ============================================== #
  # Other Devices
  # ============================================== #

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  
  # ============================================== #
  # Users / User Specific
  # ============================================== #
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.fabian = {
  #   isNormalUser = true;
  #   description = "Fabian";
  #   extraGroups = [ "networkmanager" "wheel" ];
  #   packages = with pkgs; [
  #   #  thunderbird
  #   ];
  # };
  
  
  # ============================================== #
  # Home Manager
  # ============================================== #
    
  home-manager.users.fabian = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];
    programs.bash.enable = true;

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.11";
  };
  home-manager.useGlobalPkgs = true;
    
  # ============================================== #
  # Graphics / Nvidia
  # ============================================== #
  
  hardware.graphics = {
    enable = true;
  };

  # nvidia configuration
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  
  services.xserver.videoDrivers = ["nvidia"];
  
  
  
  # ============================================== #
  # Steam / Gaming
  # ============================================== #
    
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  
  programs.gamemode.enable = true;

  # For protonup, sets its base folder
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "\\\${HOME}/.steam/root/compatibilitytools.d";
  };
  
  
  
  # ============================================== #
  # Other Apps
  # ============================================== #
  
  
  
  # ============================================== #
  # Packages
  # ============================================== #

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    nvtopPackages.nvidia
    gnome-extension-manager
    vscode
    brave
    gparted
    easyeffects
    nextcloud-client
    telegram-desktop
    git
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
