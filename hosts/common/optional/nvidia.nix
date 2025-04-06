{ config, lib, ... }:
{
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false; # You can enable this if you wish to experiment, but start with it off for troubleshooting
    powerManagement.finegrained = false; # Requires powerManagement.enable = true
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}