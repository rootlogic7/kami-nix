{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    # Stylix stylt die Farben automatisch via CSS!

    # --- Autostart via Systemd ---
    # Startet Waybar automatisch, sobald die grafische Oberfläche (Hyprland) läuft.
    systemd.enable = true;
    systemd.target = "hyprland-session.target";

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 4;
        
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];

        # --- Module Konfiguration ---
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
        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
          format = " {:%H:%M}";
          format-alt = " {:%d.%m.%Y}";
        };
	"cpu" = {
          format = " {usage}%";
          tooltip = true;
        };

        "memory" = {
          # Zeigt verbrauchten RAM in GiB anstatt nur Prozent
          format = " {used:0.1f}GiB";
          tooltip-format = "{used:0.1f}GiB / {total:0.1f}GiB ({percentage}%)";
        };

	"battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          # Jetzt mit Icons und Lade-Status
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          
          # Die Icons für die verschiedenen Füllstände
          format-icons = ["" "" "" "" ""];
        };

        "network" = {
          format-wifi = " {essid}";
          format-ethernet = " ETH";
          format-linked = "{ifname} (No IP)";
          format-disconnected = " Disconnected";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-bluetooth-muted = "  ";
          format-muted = " ";
          
          # Lautsprecher-Icons je nach Lautstärke
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
