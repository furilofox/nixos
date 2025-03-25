{
  description = "My NixOs configuration";

  inputs = {
    # Nix ecosystem
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    systems.url = "github:nix-systems/default-linux";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO: Implement Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # TODO: Customize System
    nix-colors.url = "github:misterio77/nix-colors";
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
    
    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});

    nixosConfigurations = {
      # Main desktop
      main-desktop = lib.nixosSystem {
        modules = [./hosts/main-desktop];
        specialArgs = {
          inherit inputs outputs;
        };
      };
      test-vm = lib.nixosSystem {
        modules = [./hosts/test-vm];
        specialArgs = {
          inherit inputs outputs;
        };
      };
    };
  };
}
