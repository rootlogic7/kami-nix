{ pkgs, ... }:

{
  stylix = {
    enable = true;
    
    # Dein Killua Wallpaper
    image = ./wallpaper.png; 

    # --- DAS KILLUA "GODSPEED" FARBSCHEMA ---
    # Statt einer Datei definieren wir die 16 Farben hier manuell.
    # Stylix injiziert diese automatisch in Waybar, Kitty, Hyprland etc.
    base16Scheme = {
      base00 = "0a0e17"; # Hintergrund: Extrem dunkles Blau/Schwarz (Assassinen-Stealth)
      base01 = "111827"; # Etwas hellerer Hintergrund (z.B. für Rofi)
      base02 = "1f2937"; # Selection / Inactive Borders
      base03 = "374151"; # Kommentare / Ausgegrautes
      base04 = "9ca3af"; # Dunklerer Text
      base05 = "f3f4f6"; # Standard-Text: Grellelweiß (Killuas Haare)
      base06 = "e5e7eb"; # Heller Text
      base07 = "ffffff"; # Pures Weiß
      
      base08 = "ef4444"; # Rot: Warnungen / Blut (Assassinen-Modus)
      base09 = "f97316"; # Orange
      base0A = "fbbf24"; # Gelb: Blitze / Strom
      base0B = "10b981"; # Grün: Erfolg / Safe
      
      base0C = "00e5ff"; # Cyan: Grelles Godspeed-Elektroblau (Wichtig für Akzente!)
      base0D = "3b82f6"; # Blau: Haupt-Akzentfarbe (Zoldyck Blau)
      base0E = "8b5cf6"; # Lila/Violett: Killuas Aura / Yo-Yos (Wird in deiner Waybar als Linie genutzt!)
      base0F = "ec4899"; # Pink
    };

    polarity = "dark";

    # --- SCHRIFTARTEN ---
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

    # --- CURSOR ---
    # Ein blitzschneller, scharfer weißer Cursor
    cursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 24;
    };

    # --- TRANSPARENZ ---
    opacity = {
      applications = 0.90;
      terminal = 0.85;     # Kitty etwas transparenter für den coolen Look
      desktop = 1.0;
      popups = 0.90;
    };

    targets = {
      console.enable = false;
    };
  };
}
