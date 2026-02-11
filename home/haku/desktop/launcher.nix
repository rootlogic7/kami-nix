{ pkgs, config, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi; # Wichtig für Hyprland!
    
    # Stylix übernimmt auch hier automatisch das Theming (Farben/Fonts).
    # Wir können aber das Verhalten anpassen:
    extraConfig = {
      modi = "drun,run";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 󰕰  Window";
      sidebar-mode = true;
    };
  };
}
