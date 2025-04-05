{
  services = {
    xserver = {
        enable = true;
        desktopManager.gnome = {
            enable = true;
        };
        displayManager.gdm = {
            enable = true;
            autoSuspend = false;
        };
        videoDrivers = ["nvidia"];
        xkb = {
            layout = "de";
           variant = "";
        };
        # Force Wayland
        displayManager.gdm.wayland = true;
    };  
    gnome.games.enable = true;
  };
}