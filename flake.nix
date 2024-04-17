{
  description = "My NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
    let
      inherit (self) outputs;

      system = "x86_64-linux";
      modulePath = ./modules;

      specialArgs = {
        inherit inputs system modulePath;
      };

      systemOverlays = { pkgs, ... }: {
        nixpkgs.overlays = [
          inputs.neovim-nightly-overlay.overlay
        ];
      };

      homeOverlays = { pkgs, ... }@args: systemOverlays args; 
    in {
      nixosConfigurations.nixos-venus = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          inputs.nixos-wsl.nixosModules.wsl
          systemOverlays
          ./hosts/nix-venus
        ];
      };

      nixosConfigurations.nixos-pvue = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          inputs.nixos-wsl.nixosModules.wsl
          systemOverlays
          ./hosts/nix-pvue
        ];
      };

      homeConfigurations."jtaylor@nixos-venus" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs outputs modulePath; };
        modules = [
          homeOverlays
          inputs.nixvim.homeManagerModules.nixvim
          ./hosts/nix-venus/users/jtaylor
        ];
      };

      homeConfigurations."jtaylor@nixos-pvue" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs outputs modulePath; };
        modules = [
          homeOverlays
          inputs.nixvim.homeManagerModules.nixvim
          ./hosts/nix-pvue/users/jtaylor
        ];
      };
    };
}
