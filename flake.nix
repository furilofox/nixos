{
  description = "Your new nix config";

  inputs = {
    # Nix ecosystem
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    systems.url = "github:nix-systems/default-linux";
    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Implement Secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Customize System
    nix-colors = {
      url = "github:misterio77/nix-colors";
    };

    # TODO: Implement Impermanence
    impermanence = {
      url = "github:nix-community/impermanence";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    systems,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs (import systems) (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );
  in {
    inherit lib;
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    formatter = forEachSystem (pkgs: pkgs.alejandra);

    # Names used are Moons with names i like
    # Used: luna
    # Unused: callisto, rhea, mimas, triton, hyperion, phobos, pandora, atlas, titan, europa

    # Available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {
      # Main desktop
      luna = lib.nixosSystem {
        modules = [./hosts/luna];
        specialArgs = {
          inherit inputs outputs;
        };
      };

    };

    # Available through 'home-manager --flake .#username@hostname'
    homeConfigurations = {
      # Main desktop
      "fabian@luna" = lib.homeManagerConfiguration {
        modules = [ ./home/fabian/luna.nix ./home/fabian/nixpkgs.nix ];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = { inherit inputs outputs; };
      };

    };
  };
}
