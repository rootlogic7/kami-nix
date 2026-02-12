{ pkgs, inputs, config, ... }:

let
  # Wir definieren das Astronaut-Theme als eigenes Paket
  sddm-astronaut = pkgs.stdenv.mkDerivation {
    name = "sddm-astronaut";
    src = pkgs.fetchFromGitHub {
      owner = "keyitdev";
      repo = "sddm-astronaut-theme";
      rev = "master";
      # ACHTUNG: Das wird beim ersten Mal fehlschlagen (Hash mismatch).
      # Nix wird dir den richtigen Hash sagen, den du dann hier einträgst!
      sha256 = "sha256-+94WVxOWfVhIEiVNWwnNBRmN+d1kbZCIF10Gjorea9M";
    };
    installPhase = ''
      mkdir -p $out/share/sddm/themes/sddm-astronaut-theme
      cp -r * $out/share/sddm/themes/sddm-astronaut-theme/
      
      cd $out/share/sddm/themes/sddm-astronaut-theme
      chmod +w Themes/astronaut.conf

      # --- BILD & SCHRIFT ---
      # Wir erzwingen das Ersetzen (s|...|...|), damit keine doppelten Einträge entstehen
      sed -i 's|^Background=.*|Background=${config.stylix.image}|' Themes/astronaut.conf
      sed -i 's|^Font=.*|Font=${config.stylix.fonts.sansSerif.name}|' Themes/astronaut.conf

      # --- FARBEN (Explizites Mapping) ---
      
      # MainColor: Der Rahmen um das Feld. 
      # Wir nehmen base0E (bei Catppuccin: Mauve) oder base08 (Rot) für Akzent.
      sed -i 's|^MainColor=.*|MainColor=#${config.lib.stylix.colors.base0E}|' Themes/astronaut.conf
      
      # AccentColor: Highlights. Wir nehmen base0D (Blau) für Kontrast.
      sed -i 's|^AccentColor=.*|AccentColor=#${config.lib.stylix.colors.base0D}|' Themes/astronaut.conf
      
      # FontColor: Textfarbe -> base05 (Weiß/Text)
      sed -i 's|^FontColor=.*|FontColor=#${config.lib.stylix.colors.base05}|' Themes/astronaut.conf

      # WICHTIG: FormBackgroundColor
      # Wir nehmen base00 (Hintergrund) und hängen "cc" an für Transparenz (Hex Code: #RRGGBBcc)
      # Das sorgt dafür, dass das Eingabefeld dunkel ist und sich abhebt.
      sed -i 's|^FormBackgroundColor=.*|FormBackgroundColor=#${config.lib.stylix.colors.base00}cc|' Themes/astronaut.conf
    '';
  };
in
{
  hardware.graphics.enable = true;

  # --- Hyprland ---
  programs.hyprland.enable = true;

  # --- Display Manager (SDDM) ---
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm; # Qt6 Standard
    
    # Theme Aktivierung
    theme = "sddm-astronaut-theme";
    
    # X11 Backend ist am sichersten für Login-Themes
    wayland.enable = false;
    enableHidpi = true;

    extraPackages = with pkgs.kdePackages; [
    qtsvg
      qtmultimedia
      qtdeclarative
      qtvirtualkeyboard
      # GStreamer Plugins für Video-Playback (mp4/mkv)
      pkgs.gst_all_1.gstreamer
      pkgs.gst_all_1.gst-plugins-base
      pkgs.gst_all_1.gst-plugins-good
      pkgs.gst_all_1.gst-plugins-bad
      pkgs.gst_all_1.gst-plugins-ugly
      pkgs.gst_all_1.gst-libav
    ];
  };

  services.displayManager.defaultSession = "hyprland";

  # --- XServer (für SDDM X11 Backend) ---
  services.xserver = {
    enable = true;
    xkb = {
      layout = "de";
      variant = "";
    };
  };
  
  console.useXkbConfig = true;

  # --- Fonts & Sonstiges ---
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
  ];

  # --- Theme Paket installieren ---
  environment.systemPackages = [
    sddm-astronaut
    # Weitere Pakete...
  ];
}
