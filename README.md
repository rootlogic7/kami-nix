🐉 Kami-Nix

"Once you've met someone, you never really forget them. It just takes a while for your memories to return." — Zeniba

Kami-Nix ist eine deklarative, reproduzierbare NixOS-Konfiguration, inspiriert von der Ästhetik des Studio Ghibli. Sie verwaltet die "Geister" (Hosts) und ihre Fähigkeiten zentral über Nix Flakes.

🏯 Die Geister (Hosts)

Hostname

Gerät

Rolle

Specs & Besonderheiten

shikigami

Lenovo ThinkPad T470

Der Helfer

i5-6300U, 8GB RAM 



 FS: Btrfs auf LUKS 



 Scheduler: scx_lavd (Latency opt.)

kohaku

High-End Desktop

Der Flussgeist

(TBD) 



 FS: ZFS/Btrfs (TBD) 



 Scheduler: scx_rustland (Throughput opt.)

generic

(Template)

Der Gast

Flexibel anpassbar für Kollegen

🛠️ Tech Stack (Global)

Diese Technologien bilden das Fundament für alle Geister:

Basis: NixOS 25.11 (Stable) für das System, Unstable für User-Apps.

Kernel: linux-cachyos (Optimiert via Chaotic-Nyx).

Desktop: Hyprland (Wayland).

Theming: Stylix (Globales Theming für System & Apps).

Secrets: Sops-Nix (Age Verschlüsselung).

🔮 Beschwörung (Installation)

Voraussetzung

Booten vom offiziellen NixOS 25.11 ISO.

1. Vorbereitung & Partitionierung

# Zum Root werden
sudo -i

# Repo klonen (nach /mnt, da wir noch kein System haben)
# Ersetze <DEIN-GITHUB-USER> durch deinen echten Benutzernamen
git clone [https://github.com/](https://github.com/)<DEIN-GITHUB-USER>/kami-nix /tmp/kami-nix

# Partitionierung & Formatierung (ACHTUNG: Löscht alle Daten!)
# Wähle die passende Konfiguration für den Host (z.B. shikigami):
nix run github:nix-community/disko -- --mode disko /tmp/kami-nix/hosts/shikigami/disko.nix


2. Installation

# Die Konfiguration installieren (Hostnamen anpassen!)
nixos-install --flake /tmp/kami-nix#shikigami

# Kopieren des Repos in das neue System für spätere Nutzung
mkdir -p /mnt/etc/nixos
cp -r /tmp/kami-nix/* /mnt/etc/nixos/


3. Erwachen

Rebooten und als User haku mit dem initialen Passwort anmelden.

reboot


4. Nach dem Erwachen (Secrets)

Nach dem ersten Login müssen die Sops-Keys generiert werden, falls nicht vorhanden.

mkdir -p ~/.config/sops/age
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > ~/.config/sops/age/keys.txt"


🌊 Struktur

flake.nix: Der Einstiegspunkt (Spellbook).

hosts/: Hardware-Spezifische Konfigurationen.

modules/: Wiederverwendbare System-Module.

home/: Home-Manager Konfigurationen (User-Space).

themes/: Visuelles Design (Stylix).

Gepflegt von Haku.
