{ pkgs, config, lib, ... }:

{
  stylix.targets.waybar.enable = false;

  programs.waybar = {
    enable = true;

    # --- CSS STYLING ---
    style = ''
      * {
        font-family: "${config.stylix.fonts.monospace.name}";
        font-weight: bold;
      }
      
      window#waybar {
        background-color: #${config.lib.stylix.colors.base00};
        color: #${config.lib.stylix.colors.base05};
        border-bottom: 2px solid #${config.lib.stylix.colors.base0E};
      }

      /* --- WORKSPACES --- */
      #workspaces button {
        padding: 0 5px;
        color: #${config.lib.stylix.colors.base0D};
        
        background: transparent;
        background-image: none;
        border: none;
        border-bottom: none;
        outline: none;
        box-shadow: none;
        text-shadow: none;
        border-radius: 0px;
      }

      #workspaces button:hover,
      #workspaces button:focus,
      #workspaces button.active {
        background-color: transparent;
        background-image: none;
        border: none;
        border-bottom: 0px solid transparent;
        outline: none;
        box-shadow: none;
      }

      #workspaces button.empty { color: #${config.lib.stylix.colors.base03}; }
      #workspaces button.active { color: #${config.lib.stylix.colors.base0B}; }
      #workspaces button.urgent { color: #${config.lib.stylix.colors.base08}; }

      /* --- FENSTERTITEL --- */
      #window {
        color: #${config.lib.stylix.colors.base05};
        padding: 0 10px;
      }

      /* --- MODULE LAYOUT --- */
      /* Wir entfernen die großen Margins, da wir jetzt Trennstriche haben */
      #clock, #cpu, #memory, #battery, #network, #pulseaudio, #tray, #custom-sep {
        padding: 0 6px;
      }
      #tray {
        padding: 0 10px;
        margin: 0 4px;
        min-width: 80px; 
      }
      #tray menu {
        background-color: #${config.lib.stylix.colors.base00};
        color: #${config.lib.stylix.colors.base05};
      }
      /* --- TRENNSTRICHE --- */
      #custom-sep {
        color: #${config.lib.stylix.colors.base03}; /* Dunkelgrau, damit sie nicht ablenken */
      }

      /* --- STATUS FARBEN (Gilt nur für die Kanji-Symbole!) --- */
      
      #clock { color: #${config.lib.stylix.colors.base0D}; } /* Zeit-Symbol: Blau */

      /* CPU & MEMORY */
      #cpu, #memory { color: #${config.lib.stylix.colors.base0B}; } /* Normal: Grün */
      #cpu.warning, #memory.warning { color: #${config.lib.stylix.colors.base0A}; } /* Warnung: Gelb */
      #cpu.critical, #memory.critical { color: #${config.lib.stylix.colors.base08}; } /* Kritisch: Rot */

      /* BATTERIE */
      #battery { color: #${config.lib.stylix.colors.base0B}; }
      #battery.charging { color: #${config.lib.stylix.colors.base0D}; }
      #battery.warning:not(.charging) { color: #${config.lib.stylix.colors.base0A}; }
      #battery.critical:not(.charging) { 
        color: #${config.lib.stylix.colors.base08};
        animation-name: blink; 
        animation-duration: 0.5s; 
        animation-iteration-count: infinite; 
        animation-direction: alternate; 
      }

      /* NETZWERK */
      #network { color: #${config.lib.stylix.colors.base0B}; }
      #network.disconnected { color: #${config.lib.stylix.colors.base08}; }

      /* AUDIO */
      #pulseaudio { color: #${config.lib.stylix.colors.base0D}; }
      #pulseaudio.muted { color: #${config.lib.stylix.colors.base03}; }

      @keyframes blink {
        to { color: #${config.lib.stylix.colors.base00}; }
      }
    '';

    # --- LOGIK & INHALT ---
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 0; # Spacing auf 0, da die Trennstriche den Platz einnehmen
        
        # Die Module mit Trennstrichen (custom/sep) versehen
        modules-left = [ "hyprland/workspaces" "custom/sep" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "custom/sep" "network" "custom/sep" "cpu" "custom/sep" "memory" "custom/sep" "battery" "custom/sep" "tray" ];

        # --- DER TRENNSTRICH ---
        "custom/sep" = {
          format = "｜";
          tooltip = false;
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          
          # Optionales Gimmick: Japanische Zahlen für die Workspaces!
          format = "{icon}";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "default" = "〇";
          };
          persistent-workspaces = {
             "1" = []; "2" = []; "3" = []; "4" = []; "5" = [];
          };
        };

        "hyprland/window" = {
            max-length = 50;
	    swap-icon-label = false;
        };

        # HIER PASSIERT DIE MAGIE:
        # Kanji-Symbol (nimmt die CSS-Farbe an) + Span-Text (wird auf base05/weiß gezwungen)

        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
          format = "時 <span color='#${config.lib.stylix.colors.base05}'>{:%H:%M}</span>";
          format-alt = "日 <span color='#${config.lib.stylix.colors.base05}'>{:%d.%m.%Y}</span>";
        };

        "cpu" = {
          format = "核 <span color='#${config.lib.stylix.colors.base05}'>{usage}%</span>";
          tooltip = true;
          states = { warning = 70; critical = 90; };
        };

        "memory" = {
          format = "憶 <span color='#${config.lib.stylix.colors.base05}'>{used:0.1f}GiB</span>";
          tooltip-format = "{used:0.1f}GiB / {total:0.1f}GiB ({percentage}%)";
          states = { warning = 70; critical = 90; };
        };

        "battery" = {
          states = { warning = 30; critical = 15; };
          format = "電 <span color='#${config.lib.stylix.colors.base05}'>{capacity}%</span>";
          format-charging = "雷 <span color='#${config.lib.stylix.colors.base05}'>{capacity}%</span>";
          format-plugged = "繋 <span color='#${config.lib.stylix.colors.base05}'>{capacity}%</span>";
        };

        "network" = {
          format-wifi = "網 <span color='#${config.lib.stylix.colors.base05}'>{essid}</span>";
          format-ethernet = "線 <span color='#${config.lib.stylix.colors.base05}'>ETH</span>";
          format-linked = "線 <span color='#${config.lib.stylix.colors.base05}'>{ifname} (No IP)</span>";
          format-disconnected = "断 <span color='#${config.lib.stylix.colors.base05}'>Offline</span>";
        };

        "pulseaudio" = {
          format = "音 <span color='#${config.lib.stylix.colors.base05}'>{volume}%</span>";
          format-bluetooth = "波 <span color='#${config.lib.stylix.colors.base05}'>{volume}%</span>";
          format-muted = "静 <span color='#${config.lib.stylix.colors.base05}'>Muted</span>";
          on-click = "pavucontrol";
        };
        
        "tray" = {
          icon-size = 18;
          spacing = 10;
	  show-passive-items = true;
        };
      };
    };
  };
}
