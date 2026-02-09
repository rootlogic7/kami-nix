{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            # 1. Boot Partition (ESP) - Hier liegen die Bootloader-Dateien
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            # 2. Verschlüsselter Container (LUKS) - Der Rest der Platte
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                # Wir deaktivieren hier settings.keyFile, damit wir beim Booten
                # nach dem Passwort gefragt werden.
                settings = {
                  allowDiscards = true; # Wichtig für SSD TRIM (Performance/Lebensdauer)
                };
                # Innerhalb der Verschlüsselung liegt Btrfs
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ]; # Force overwrite
                  subvolumes = {
                    # Root System
                    "@" = {
                      mountpoint = "/";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    # Home Verzeichnis (Deine persönlichen Daten)
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    # Nix Store (Kann groß werden, profitiert von Kompression)
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                    # Logs (Separat, damit wir bei Rollbacks nicht Logs verlieren)
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = [ "compress=zstd" "noatime" ];
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
