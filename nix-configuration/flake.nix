{
  description = "My environment configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    disko,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib;

    constants = import ./constants.nix {inherit lib;};
    utils = import ./utils.nix {inherit lib nixpkgs;};
    common = {
      inherit utils constants;
    };

    configureHome = {
      host,
      system,
    }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = utils.pkgsForSystem {inherit system;};

        extraSpecialArgs = {
          inherit
            inputs
            outputs
            system
            common
            ;
        };

        modules = [
          ./definitions.nix
          ./home.nix
          ./hosts/${host}/home.nix
        ];
      };

    configureNixos = {
      host,
      system,
    }:
      lib.nixosSystem {
        specialArgs = {
          inherit
            inputs
            outputs
            system
            common
            ;
        };

        modules = [
          ./definitions.nix
          disko.nixosModules.disko
          ./hosts/${host}/configuration.nix
          home-manager.nixosModules.home-manager
          ({config, ...}: {
            home-manager = {
              useGlobalPkgs = lib.mkDefault true;
              useUserPackages = lib.mkDefault true;

              extraSpecialArgs = {
                inherit
                  inputs
                  outputs
                  system
                  common
                  ;
              };

              users.${config.definitions.username} = lib.mkMerge [
                ./definitions.nix
                ./home.nix
                ./hosts/${host}/home.nix
              ];
            };
          })
        ];
      };
  in {
    homeConfigurations = {
      pc-windows = configureHome {
        host = "pc-windows";
        system = constants.systems.linuxPc;
      };

      mac = configureHome {
        host = "mac";
        system = constants.systems.macArm;
      };
    };

    nixosConfigurations = {
      laptop-gs75 = configureNixos {
        host = "laptop-gs75";
        system = constants.systems.linuxPc;
      };
    };
  };
}
