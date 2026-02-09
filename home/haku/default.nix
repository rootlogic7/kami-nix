{ pkgs, ... }:

{
  imports = [
    # Wir gliedern die Konfiguration in logische Module
    ./shell    # Zsh, Starship, Yazi, Git
    ./desktop  # Hyprland, Waybar, Rofi, Theme-Anpassungen
    ./apps     # Browser, Neovim, Tools
  ];

  # --- User Info ---
  home.username = "haku";
  home.homeDirectory = "/home/haku";

  # --- Environment Variables ---
  # Diese Variablen gelten für deine Shell und GUI-Apps
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  # --- Home Manager State Version ---
  # Definiert die Version der ersten Installation.
  # Hilft Home-Manager, Änderungen über die Zeit kompatibel zu halten.
  # NICHT ÄNDERN.
  home.stateVersion = "25.11";

  # --- Self-Management ---
  # Lässt Home-Manager sich selbst verwalten
  programs.home-manager.enable = true;
}
