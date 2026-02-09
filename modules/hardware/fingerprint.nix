{ pkgs, ... }:

{
  # Daemon zur Verwaltung von Fingerabdruck-Lesern
  services.fprintd.enable = true;

  # Integration in den Login-Prozess (SDDM/GDM/Console)
  # Damit kannst du dich mit dem Finger statt Passwort einloggen.
  security.pam.services.login.fprintAuth = true;

  # Optional: Auch für 'sudo' nutzen (auskommentiert, da Geschmackssache)
  # security.pam.services.sudo.fprintAuth = true;
  
  # Falls Hyprlock (der Lockscreen) später genutzt wird, muss das dort separat konfiguriert werden.
}
