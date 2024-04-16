{
  description = "My NixOS configuration";


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

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

  outputs = { self, nixpkgs, home-manager, nixvim, nixos-wsl, ... }@inputs: 
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      modulePath = ./modules;
      specialArgs = {
        inherit inputs system modulePath;
      };
    in {
      nixosConfigurations.nixos-venus = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          nixos-wsl.nixosModules.wsl
          ./hosts/nix-venus
        ];
      };

      nixosConfigurations.nixos-pvue = nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          nixos-wsl.nixosModules.wsl
          ./hosts/nix-pvue
        ];
      };

      homeConfigurations."jtaylor@nixos-venus" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs outputs modulePath; };
        modules = [
          nixvim.homeManagerModules.nixvim
          ./hosts/nix-venus/users/jtaylor
        ];
      };

      homeConfigurations."jtaylor@nixos-pvue" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs outputs modulePath; };
        modules = [
          nixvim.homeManagerModules.nixvim
          ./hosts/nix-pvue/users/jtaylor
        ];
      };
    };
}
