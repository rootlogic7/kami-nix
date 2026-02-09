{ pkgs, config, lib, ... }:

{
  imports = [
    # Die Hardware-Erkennung (generiert)
    ./hardware-configuration.nix
    # Die Partitionierung
    ./disko.nix

    # --- Hardware Module ---
    # Hier aktivieren wir die spezifischen Fähigkeiten des Laptops
    ../../modules/hardware/audio.nix
    ../../modules/hardware/bluetooth.nix
    ../../modules/hardware/fingerprint.nix

    # --- Desktop ---
    ../../modules/desktop/default.nix

  ];

  # --- Identität ---
  networking.hostName = "shikigami";
  
  # --- Kernel & Scheduler (CachyOS Magic) ---
  # Nutzung des optimierten CachyOS Kernels
  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  # Scheduler-Ext (scx) Aktivierung
  # scx_lavd ist optimiert für Latenz & Interaktivität (perfekt für Desktop/Gaming auf weniger Kernen)
  services.scx = {
    enable = true;
    scheduler = "scx_lavd"; 
  };

  # --- Speicher Optimierung (für 8GB RAM) ---
  # ZRAM erstellt einen komprimierten Swap im RAM. 
  # Das verhindert, dass der PC einfriert, wenn der RAM vollläuft.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # --- Power Management (T470 Spezifisch) ---
  # Da dies ein Laptop ist, aktivieren wir TLP für bessere Batterielaufzeit
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      
      # Begrenzung der Ladung zur Schonung der Batterie (ThinkPad Feature)
      # STOP bei 80%, START bei 75%
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # Firmware Updates via fwupd aktivieren (wichtig für ThinkPads)
  services.fwupd.enable = true;

  # --- State Version ---
  # Definiert die NixOS Version der ersten Installation. 
  # NICHT ÄNDERN, auch nicht bei Updates.
  system.stateVersion = "25.11";
}
