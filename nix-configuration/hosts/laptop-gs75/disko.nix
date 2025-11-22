{
  disko.devices.disk = {
    nvme0n1 = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            label = "boot";
            type = "EF00";
            size = "1024M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [
                "umask=0077"
              ];
            };
          };

          swap = {
            label = "swap";
            size = "16G";
            content = {
              type = "swap";
              randomEncryption = true;
              resumeDevice = true;
            };
          };

          root = {
            label = "root";
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              mountpoint = null;

              subvolumes = {
                "@" = {
                  mountpoint = "/";
                };

                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd"
                  ];
                };

                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
