# --- Müllabfuhr ---
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  
  # Speicherplatz optimieren (Hardlinks für identische Dateien)
  nix.settings.auto-optimise-store = true;
