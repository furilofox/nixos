{
  description = "My NixOS configuration";

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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Implement Impermanence
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
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

    # Names used are Moons, Current and Future Names:
    # Used: luna, europa
    # Unused: callisto, rhea, mimas, triton, hyperion, phobos, pandora, atlas, titan

    nixosConfigurations = {
      # Main desktop
      luna = lib.nixosSystem {
        modules = [./hosts/luna];
        specialArgs = {
          inherit inputs outputs;
        };
      };

      # Test VM
      europa = lib.nixosSystem {
        modules = [./hosts/europa];
        specialArgs = {
          inherit inputs outputs;
        };
      };

    };

    homeConfigurations = {
      # Main desktop
      "fabian@luna" = lib.homeManagerConfiguration {
        modules = [ ./home/fabian/luna.nix ./home/fabian/nixpkgs.nix ];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
      };

      # Test VM
      "fabian@europa" = lib.homeManagerConfiguration {
        modules = [ ./home/fabian/europa.nix ./home/fabian/nixpkgs.nix ];
        pkgs = pkgsFor.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
        };
      };
    };
  };
}