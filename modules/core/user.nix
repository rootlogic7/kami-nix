{ pkgs, ... }:

{
  # Damit Zsh als Login-Shell funktioniert, muss sie systemweit aktiviert sein
  programs.zsh.enable = true;

  users.users.haku = {
    isNormalUser = true;
    description = "Haku - The River Spirit";
    
    # Wichtige Gruppen-Mitgliedschaften:
    # - networkmanager: Erlaubt Nutzung von nm-applet / nmtui
    # - wheel: Erlaubt Nutzung von 'sudo'
    # - video/audio: Hardware-Zugriff (wichtig für Wayland/Pipewire)
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
    
    # Die Standard-Shell
    shell = pkgs.zsh;
    
    # ACHTUNG: Unsicheres Initial-Passwort für die erste Installation.
    # Ändere es nach dem ersten Login mit dem Befehl 'passwd'
    # und entferne diese Zeile später oder nutze sops-nix.
    initialPassword = "susuwatari";
  };
}
