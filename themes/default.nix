{ pkgs, ... }:

{
  stylix = {
    enable = true;
    
    # --- Das Herzstück: Hintergrundbild ---
    # Stylix generiert daraus auch die Farben, wenn kein explizites Schema gesetzt ist.
    # WICHTIG: Lege ein Bild namens 'wallpaper.jpg' in den Ordner 'themes/assets/'!
    image = ./assets/wallpaper.jpg;

    # --- Farbschema (Base16) ---
    # "Catppuccin Mocha" passt perfekt zu den tiefen Blau/Teal-Tönen von Haku.
    # Alternativen: "gruvbox-dark-hard" (für Bathhouse vibes) oder "nord".
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    polarity = "dark";

    # --- Schriftarten ---
    # Konsistente Fonts überall im System
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        # JetBrainsMono Nerd Font ist der Goldstandard für Coding & Terminal
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      
      sizes = {
        terminal = 12;
        applications = 11;
        desktop = 11;
      };
    };

    # --- Mauszeiger ---
    # "Bibata-Modern-Ice" ist clean, modern und passt zum Drachen-Thema (Weiß/Blau)
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    # --- Transparenz & Unschärfe ---
    # Sorgt für den modernen "Glass"-Look in Terminals und Fenstern
    opacity = {
      applications = 0.95;
      terminal = 0.90;
      desktop = 1.0;
      popups = 0.95;
    };

    # 3. Targets verwalten
    targets = {
      # Wenn du die TTY (Boot-Nachrichten/Konsole) NICHT gefärbt haben willst:
      console.enable = false; 
      
      # SDDM machen wir ja manuell, also hier deaktiviert lassen (wie im Code zuvor gelöscht)
      # sddm.enable = false; # (Nicht nötig einzufügen, wenn es schon weg ist)
    };
  };
}
