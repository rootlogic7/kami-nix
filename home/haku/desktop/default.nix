{ pkgs, config, lib, ... }:

{
  imports = [
    ./waybar.nix
    ./launcher.nix
    ./hyprlock.nix
  ];

  home.packages = with pkgs; [
    # Screenshot Tool
    hyprshot
    # Optional: wl-clipboard (falls noch nicht da), damit Hyprshot in die Zwischenablage kopieren kann
    wl-clipboard 
  ];

  # --- Hyprland Konfiguration ---
  wayland.windowManager.hyprland = {
    enable = true;
    
    # Stylix konfiguriert automatisch Farben, Rahmen und Schriftarten!
    # Wir kümmern uns hier nur um die Logik.
    settings = {
      # --- MONITOR SETUP ---
      monitor = [
        # DP-4 (Extern): 1280x1024, beginnt bei X=43, Y=0 (oben, zentriert)
        "DP-4,1280x1024@60.02,43x0,1"
        
        # eDP-1 (Laptop): 1366x768, beginnt bei X=0, Y=1024 (unten, unter DP-4)
        "eDP-1,1366x768@60.06,0x1024,1"
        
        # Fallback: Falls du mal einen anderen Monitor ansteckst
        ",preferred,auto,1"
      ];

      # Variablen Definition
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "kitty -e yazi";
      "$menu" = "rofi -show drun -show-icons";
      "$browser" = "firefox";

      exec-once = [
        "waybar"
        "nm-applet --indicator"
        "blueman-applet"
        # "hyprpaper" # Falls du hyprpaper statt Stylix nutzt
      ];

      # --- Eingabegeräte ---
      input = {
        kb_layout = "de";
        kb_variant = "";
        follow_mouse = 1;
        
        # Touchpad Einstellungen (T470)
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          tap-to-click = true;
        };
      };

      # --- Gesten (Touchscreen/Touchpad) ---
      gestures = {
        # workspace_swipe = true;
        # workspace_swipe_fingers = 3;
      };

      # --- Aussehen & Verhalten ---
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "dwindle"; # Das Standard Tiling-Layout
	"col.active_border" = lib.mkForce "rgb(${config.lib.stylix.colors.base0E})";
        "col.inactive_border" = lib.mkForce "rgb(${config.lib.stylix.colors.base02})";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        # Schatten für Tiefe
        shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # --- Keybindings (Die Zaubersprüche) ---
      bind = [
        # Apps starten
        "$mod, Return, exec, $terminal"
        "$mod, E, exec, $fileManager"
        "$mod, B, exec, $browser"
        "$mod, Space, exec, $menu"

        # Fensterverwaltung
        "$mod, Q, killactive,"
        "$mod, F, togglefloating,"
        "$mod, P, pseudo," # Dwindle Effekt
        "$mod, Z, togglesplit," # Horizontal/Vertikal Switch

        # Fokus bewegen (Pfeiltasten oder HJKL)
        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"
        # Workspaces wechseln (1-10)
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        
        # Fenster auf Workspace verschieben
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"

        # Special Workspace (Scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        
	# Screenshot: Ganzer Monitor -> Clipboard
        ", PRINT, exec, hyprshot -m output --clipboard-only"
        
        # Screenshot: Aktives Fenster -> Clipboard
        "$mod, PRINT, exec, hyprshot -m window --clipboard-only"

        # Screenshot: Region auswählen -> Clipboard (Der wichtigste!)
        "$mod SHIFT, S, exec, hyprshot -m region --clipboard-only"
        # Maus-Bewegung
        # "mouse:272, movewindow"
        # "mouse:273, resizewindow"
      ];
      # bindm = [
	# "mouse:272, movewindow"
	# "mouse:273, resizewindow"
      # ];

      # Media Keys (Lautstärke, Helligkeit) - Wichtig für Laptop!
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
    };
  };
  # Notification Daemon (Mako)
  services.mako = {
    enable = true;
    # NEU: Settings Block statt direkter Option
    settings = {
      default-timeout = 5000;
    };
    # Stylix übernimmt das Styling (Farben, Fonts, Border)
  };
}
