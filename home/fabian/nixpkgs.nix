# This file should be included when using hm standalone https://github.com/Misterio77/nix-config/blob/main/home/gabriel/nixpkgs.nix
{
  outputs,
  lib,
  inputs,
  ...
}: let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in {
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
    };
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
  };

  home.sessionVariables = {
    NIX_PATH = lib.concatStringsSep ":" (lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs);
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
}