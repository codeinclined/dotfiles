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
    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

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

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;

      system = "x86_64-linux";
      modulePath = ./modules;

      specialArgs = {
        inherit inputs system modulePath;
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      };

      systemOverlays = _: {
        nixpkgs.overlays = [
          # inputs.neovim-nightly-overlay.overlay
        ];
      };

      homeOverlays = systemOverlays;
    in
    {
      nixosConfigurations = {
        nixos-venus = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = with inputs.nixos-hardware.nixosModules; [
            common-cpu-amd-pstate
            common-pc-ssd
            ./hosts/nixos-venus
          ];
        };

        nixos-wsl-venus = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            inputs.nixos-wsl.nixosModules.wsl
            systemOverlays
            ./hosts/nixos-wsl-venus
          ];
        };

        nixos-wsl-pvue = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            inputs.nixos-wsl.nixosModules.wsl
            systemOverlays
            ./hosts/nixos-wsl-pvue
          ];
        };
      };

      homeConfigurations = {
        "jtaylor@nixos-venus" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
          extraSpecialArgs = { inherit inputs outputs modulePath; };
          modules = [
            homeOverlays
            inputs.nixvim.homeManagerModules.nixvim
            inputs.plasma-manager.homeManagerModules.plasma-manager
            ./hosts/nixos-venus/users/jtaylor
          ];
        };

        "jtaylor@nixos-wsl-venus" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs outputs modulePath; };
          modules = [
            homeOverlays
            inputs.nixvim.homeManagerModules.nixvim
            ./hosts/nixos-wsl-venus/users/jtaylor
          ];
        };

        "jtaylor@nixos-wsl-pvue" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs outputs modulePath; };
          modules = [
            homeOverlays
            inputs.nixvim.homeManagerModules.nixvim
            ./hosts/nixos-wsl-pvue/users/jtaylor
          ];
        };
      };
    };
}
