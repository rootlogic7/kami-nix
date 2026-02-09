{ pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true; # Bluetooth beim Start aktivieren
    settings = {
      General = {
        # Aktiviert experimentelle Features (z.B. Akku-Anzeige für Headsets)
        Experimental = true;
      };
    };
  };

  # Blueman Applet (System Tray Icon & Manager)
  services.blueman.enable = true;
}
