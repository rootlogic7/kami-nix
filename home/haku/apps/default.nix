{ pkgs, pkgs-unstable, ... }:

{
  # --- Stylix Fix ---
  # Wir sagen Stylix explizit, welches Firefox-Profil gethemed werden soll.
  stylix.targets.firefox.profileNames = [ "default" ];
  # --- Terminal: Kitty ---
  programs.kitty = {
    enable = true;
    # Stylix kümmert sich um Farben und Fonts. 
    # Hier setzen wir nur funktionale Extras.
    settings = {
      window_padding_width = 6;  # Etwas Luft zum Atmen
      confirm_os_window_close = 0; # Nervt nicht beim Schließen
      enable_audio_bell = false; # Ruhe im Karton
    };
  };

  # --- Browser: Firefox ---
  programs.firefox = {
    enable = true;
    # Privacy-Einstellungen und Erweiterungen könnten hier später folgen.
    # Stylix wird das Theme automatisch auf Firefox anwenden (via Stylus/UserChrome).
  };

  # --- Editor: Neovim ---
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # Wir nutzen die Unstable-Version für neueste Features (LSP, Treesitter)
    package = pkgs-unstable.neovim-unwrapped; 
    
    # Minimal-Config für den Start (Haku-Style)
    extraConfig = ''
      set number relativenumber
      set clipboard+=unnamedplus
      set ignorecase smartcase
    '';
  };

  # --- Zusätzliche Geister (Apps) ---
  home.packages = with pkgs; [
    # Office & Dokumente (Terminal-zentriert)
    zathura      # Minimalistischer PDF Viewer (Perfekt für Yazi Preview)
    
    # Medien
    mpv          # Der beste Video-Player
    imv          # Schneller Image Viewer (Wayland native)
    
    # System & Monitoring
    btop         # Ressoucen-Monitor im TUI-Look
    pavucontrol  # Audio-Steuerung (GUI Fallback)
    
    # Tools
    wl-clipboard # Clipboard Support für Wayland (yazi/neovim brauchen das)
  ];
}
