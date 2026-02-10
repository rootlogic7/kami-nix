{ pkgs, ... }:

{
  imports = [
    # Wir lagern User und Security aus, um diese Datei sauber zu halten
    ./user.nix
    ./security.nix
  ];

  # --- Bootloader ---
  # Wir nutzen systemd-boot, da es minimalistisch und schnell ist.
  # Es funktioniert perfekt mit unserer ESP-Partition von Disko.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Networking ---
  # NetworkManager ist der Standard für Laptops & Desktops (WLAN, GUI).
  networking.networkmanager.enable = true;

  # --- Lokalisierung ---
  # Zeitzone: Deutschland (Berlin)
  time.timeZone = "Europe/Berlin";

  # Sprache: Englisch (US) für Systemmeldungen (besser zum Googeln von Fehlern)
  i18n.defaultLocale = "en_US.UTF-8";

  # Tastatur: Deutsch (für die Konsole)
  console.keyMap = "de";

  # --- Nix Konfiguration ---
  nix.settings = {
    # Notwendig für Flakes
    experimental-features = [ "nix-command" "flakes" ];
    
    # Optimierung: Gleiche Dateien im Store nur einmal speichern (spart Platz)
    auto-optimise-store = true;
  };

  # Garbage Collection: Wöchentlich alten Müll rausbringen
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Erlaube unfreie Pakete (z.B. Steam, Discord, Nvidia Treiber)
  nixpkgs.config.allowUnfree = true;

  # --- Basis Pakete ---
  # Diese Programme sind auf jedem Host verfügbar
  environment.systemPackages = with pkgs; [
    vim             # Notfall-Editor
    git             # Version Control
    wget            # Downloader
    curl            # Downloader
    htop            # Prozess-Viewer
    ripgrep         # Schnelles Grep
    unzip           # Archivierung
  ];
}
