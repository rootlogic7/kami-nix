{ pkgs, inputs, ... }:

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
      
      # Optional: Config anpassen (z.B. für Custom Background)
      # Wir lassen erstmal den Standard (Space Animation/Bild)
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
      qtmultimedia  # Zwingend nötig für Animationen/Videos!
      qtdeclarative
      qtvirtualkeyboard # Falls du die Tastatur doch willst, sonst weglassen
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
