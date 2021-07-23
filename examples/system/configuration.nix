# SPDX-FileCopyrightText: 2020 Serokell <https://serokell.io/>
#
# SPDX-License-Identifier: MPL-2.0

{
  imports = [ ./common.nix ];

  networking.hostName = "example-nixos-system";

  # This seems to be needed to stop deploy-rs unmounting /boot and then complaining it cannot write to /boot/loader/loader.conf
  fileSystems."/boot" = {
    device = "/dev/vdb2";
    fsType = "vfat";
  };

  users.users.hello = {
    isNormalUser = true;
    password = "";
    uid = 1010;
  };
}
