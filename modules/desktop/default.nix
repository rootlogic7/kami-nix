{ pkgs, inputs, ... }:

{
  hardware.graphics.enable = true;

  # --- Hyprland (System-Wide) ---
  programs.hyprland = {
    enable = true;
    # Wir nutzen das Hyprland-Paket aus 'unstable' für bleeding-edge Features
    #package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.hyprland;
    #portalPackage = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  # --- Display Manager (Login) ---
  # Wir nutzen SDDM, da es hervorragend mit Stylix themebar ist.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.displayManager.defaultSession = "hyprland";

  # --- Fonts ---
  # Nerd Fonts sind essentiell für Icons in Waybar, Yazi und Starship.
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome
    # Nerd Fonts (moderne Syntax für NixOS 25.05+)
    nerd-fonts.jetbrains-mono
  ];

  # --- Environment Variables ---
  environment.sessionVariables = {
    # Zwingt Electron-Apps (VS Code, Discord) dazu, Wayland zu nutzen
    NIXOS_OZONE_WL = "1";
  };

  # --- XDG Portals ---
  # Notwendig für Screen-Sharing und Datei-Öffnen-Dialoge
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  
  # --- Sonstiges ---
  # DConf ist notwendig, damit GTK-Apps ihre Einstellungen speichern können
  programs.dconf.enable = true;
  
  # Polkit Agent für GUI-Passwortabfragen
  security.polkit.enable = true;
}
