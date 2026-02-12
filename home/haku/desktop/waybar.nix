{ pkgs, config, lib, ... }:

{
  programs.waybar = {
    enable = true;
    
    # CSS Styling
    style = ''
      * {
        font-family: "${config.stylix.fonts.monospace.name}";
        font-weight: bold;
      }
      
      window#waybar {
        background-color: #${config.lib.stylix.colors.base00};
        color: #${config.lib.stylix.colors.base05};
        border-bottom: 2px solid #${config.lib.stylix.colors.base0E}; /* Lila Linie als Abschluss */
      }

      /* --- WORKSPACES --- */
      #workspaces button {
        padding: 0 5px;
        color: #${config.lib.stylix.colors.base0D}; /* Standard: Blau (Belegt) */
      }

      #workspaces button.empty {
        color: #${config.lib.stylix.colors.base03}; /* Grau (Leer) */
      }

      #workspaces button.active {
        color: #${config.lib.stylix.colors.base0B}; /* Grün (Aktiv) */
      }
      
      #workspaces button.urgent {
        color: #${config.lib.stylix.colors.base08}; /* Rot (Dringend) */
      }

      /* --- FENSTERTITEL --- */
      #window {
        color: #${config.lib.stylix.colors.base0E}; /* Mauve/Lila */
        padding: 0 10px;
      }

      /* --- UHRZEIT --- */
      #clock {
        color: #${config.lib.stylix.colors.base06}; /* Rosewater (Hell) */
        padding: 0 10px;
      }

      /* --- MODULE (Basis) --- */
      #cpu, #memory, #battery, #network, #pulseaudio, #tray {
        padding: 0 10px;
        margin: 0 4px;
      }

      /* --- CPU & MEMORY --- */
      /* Normal: Grün */
      #cpu, #memory { color: #${config.lib.stylix.colors.base0B}; }
      
      /* Warnung: Gelb */
      #cpu.warning, #memory.warning { color: #${config.lib.stylix.colors.base0A}; }
      
      /* Kritisch: Rot */
      #cpu.critical, #memory.critical { color: #${config.lib.stylix.colors.base08}; }

      /* --- BATTERY --- */
      /* Normal: Grün */
      #battery { color: #${config.lib.stylix.colors.base0B}; }
      
      /* Laden: Blau (oder Pink, je nach Geschmack. Hier Blau passend zum Schema) */
      #battery.charging { color: #${config.lib.stylix.colors.base0D}; }
      
      /* Warnung (niedrig): Gelb */
      #battery.warning:not(.charging) { color: #${config.lib.stylix.colors.base0A}; }
      
      /* Kritisch (fast leer): Rot blinkend */
      #battery.critical:not(.charging) { 
        color: #${config.lib.stylix.colors.base08}; 
        animation-name: blink; 
        animation-duration: 0.5s; 
        animation-iteration-count: infinite; 
        animation-direction: alternate; 
      }

      /* --- NETWORK --- */
      /* Verbunden: Grün */
      #network { color: #${config.lib.stylix.colors.base0B}; }
      
      /* Getrennt: Rot */
      #network.disconnected { color: #${config.lib.stylix.colors.base08}; }

      /* --- AUDIO --- */
      /* Unmuted: Blau */
      #pulseaudio { color: #${config.lib.stylix.colors.base0D}; }
      
      /* Muted: Grau */
      #pulseaudio.muted { color: #${config.lib.stylix.colors.base03}; }

      @keyframes blink {
        to { color: #${config.lib.stylix.colors.base00}; }
      }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
          persistent-workspaces = {
             "1" = [];
             "2" = [];
             "3" = [];
             "4" = [];
             "5" = [];
          };
        };
        
        "hyprland/window" = {
            max-length = 50;
        };

        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
          format = " {:%H:%M}";
          format-alt = " {:%d.%m.%Y}";
        };

        "cpu" = {
          format = " {usage}%";
          tooltip = true;
          states = {
            warning = 70;
            critical = 90;
          };
        };

        "memory" = {
          format = " {used:0.1f}GiB";
          tooltip-format = "{used:0.1f}GiB / {total:0.1f}GiB ({percentage}%)";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };

        "network" = {
          format-wifi = " {essid}";
          format-ethernet = "󰈀 ETH";
          format-linked = "󰈀 {ifname} (No IP)";
          format-disconnected = "󰤮 Disconnected";
          format-alt = "󰈀 {ifname}: {ipaddr}/{cidr}";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-bluetooth-muted = "  ";
          format-muted = " ";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
        
        "tray" = {
            icon-size = 18;
            spacing = 10;
        };
      };
    };
  };
}
