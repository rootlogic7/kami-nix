{ pkgs, ... }:

{
  # --- Sops-Nix (Secrets) ---
  #sops = {
  #  defaultSopsFile = ../../secrets/secrets.yaml;
  #  defaultSopsFormat = "yaml";

  #  # Wir nutzen primär den SSH-Host-Key zur Entschlüsselung.
  #  # Das ist der "Zero-Config" Ansatz für NixOS Hosts.
  #  # Disko und NixOS generieren diesen Key beim ersten Boot.
  #  age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  #  
  #  # Fallback: Ein manuell platziertes Keyfile (für Notfälle)
  #  age.keyFile = "/var/lib/sops-nix/key.txt";
  #  
  #  # Versucht, den Age-Key aus dem SSH-Key abzuleiten, falls er fehlt
  #  age.generateKey = true;
  #};

  # --- Audio & Performance Priority ---
  # RtKit ist ein Daemon, der Prozessen (wie PipeWire) erlaubt,
  # Realtime-Priorität anzufordern. Absolut notwendig für gutes Audio ohne Aussetzer.
  security.rtkit.enable = true;

  # --- Polkit (Berechtigungen) ---
  # Erlaubt Desktop-Apps, nach Root-Rechten zu fragen (z.B. GParted, Netzwerk-Manager).
  security.polkit.enable = true;

  # --- Sudo ---
  # Standard Sudo ist aktiviert. Die 'wheel' Gruppe (für Haku) 
  # wurde bereits in 'user.nix' zugewiesen.
  security.sudo.enable = true;
}
