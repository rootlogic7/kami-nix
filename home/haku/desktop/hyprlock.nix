{ pkgs, ... }:

{
  # --- Hyprlock (Sperrbildschirm) ---
  # Stylix übernimmt das Design (Bild, Farben, Fonts)!
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        no_fade_in = false;
        grace = 0;
        disable_loading_bar = true;
      };

      # Optional: Ein kleines Label mit der Uhrzeit, falls Stylix das nicht setzt
      label = [
        {
          text = "$TIME";
          color = "rgba(255, 255, 255, 1.0)";
          font_size = 50;
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # --- Hypridle (Idle Daemon) ---
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # Sperren, bevor der PC in den Schlaf geht
        lock_cmd = "pidof hyprlock || hyprlock"; 
        # Aufwachen: Bildschirm wieder an
        after_sleep_cmd = "hyprctl dispatch dpms on"; 
      };

      listener = [
        # 1. Helligkeit dimmen nach 2.5 Minuten
        {
          timeout = 150;
          on-timeout = "brightnessctl -s set 10"; # Merke Wert, setze auf 10
          on-resume = "brightnessctl -r";          # Stelle alten Wert wieder her
        }
        # 2. Bildschirm sperren nach 5 Minuten
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        # 3. Bildschirm ausschalten (DPMS) nach 5.5 Minuten
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        # 4. Suspend (Schlafmodus) nach 10 Minuten (nur wenn nicht am Strom)
        # (Kannst du auskommentieren, wenn du das nicht willst)
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
