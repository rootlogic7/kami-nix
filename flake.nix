{
  description = "Kami-Nix: A Ghibli-themed NixOS Configuration";

  inputs = {
    # --- Core Spirits ---
    # NixOS 25.11 Stable als Basis
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Unstable für bleeding-edge Apps
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # --- The Managers ---
    # Home Manager: Verwaltet die User-Umgebung
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko: Deklarative Partitionierung
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # --- The Magic ---
    # Chaotic Nyx: CachyOS Kernel, Scheduler & Optimierungen
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Stylix: Automatisches Theming
    stylix.url = "github:danth/stylix/release-25.11";

    # Sops-Nix: Secrets Management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, disko, chaotic, stylix, sops-nix, ... } @ inputs:
    let
      inherit (self) outputs;
      
      # Unterstützte Systeme
      systems = [ "x86_64-linux" ];
      
      # Helper, um System-Argumente konsistent zu übergeben
      mkSystem = { hostname, user, theme ? "ghibli", system ? "x86_64-linux" }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs outputs;
            # Wir geben 'pkgs-unstable' an alle Module weiter
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = [
            # Host Spezifische Config (Hardware, Disko, etc.)
            ./hosts/${hostname}

            # Core Module (Bootloader, Locales, etc.)
            ./modules/core

            # CachyOS Optimierungen
            chaotic.nixosModules.default

            # Disko Modul
            disko.nixosModules.disko

            # Sops Secrets
            sops-nix.nixosModules.sops

            # Stylix Theming
            stylix.nixosModules.stylix
	    ./themes/${theme}

            # Home Manager Integration
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs outputs;
                # Auch Home-Manager bekommt Zugriff auf Unstable
                pkgs-unstable = import nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
              };
              home-manager.users.${user} = import ./home/${user};
              
              # Backups erstellen, falls Config-Dateien schon existieren
              home-manager.backupFileExtension = "backup";
            }
          ];
        };
    in
    {
      # --- NixOS Configurations (Die Geister) ---
      nixosConfigurations = {
        
        # Der Helfer-Geist (ThinkPad T470)
        shikigami = mkSystem {
          hostname = "shikigami";
          user = "haku";
	  theme = "killua";
        };

        # Der Flussgeist (High-End PC)
        kohaku = mkSystem {
          hostname = "kohaku";
          user = "haku";
        };
        
        # Template für Kollegen
        # generic = mkSystem {
        #   hostname = "generic";
        #   user = "guest";
        # };
      };
    };
}
