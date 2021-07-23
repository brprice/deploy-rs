<!--
SPDX-FileCopyrightText: 2020 Serokell <https://serokell.io/>

SPDX-License-Identifier: MPL-2.0
-->

# Example nixos system deployment

This is an example of how to deploy a full nixos system with a separate user unit to a bare machine.

0. (If doing this multiple times, you may want to ensure you remove the `*.fd` and `*.qcow2` files so you boot up a clean version of the vm, to start from scratch)
1. Run bare system from `.#nixosConfigurations.bare`
  - `nix build .#nixosConfigurations.bare.config.system.build.vmWithBootloader`
  - `QEMU_NET_OPTS=hostfwd=tcp::2221-:22 ./result/bin/run-bare-system-vm`
2. `SSH_ASKPASS_REQUIRE=prefer nix run . -- .#example.system`
3. `nix run . -- .#example.hello`
4. See that it worked: log in to the vm as 'hello', and run `systemctl --user status hello`
   TODO: currently this complains about "Unknown key name "WantedBy" in section "Unit".
   TODO: unfortunately, the changes to the vm don't quite survive a reboot in the way one may expect, via the ./result/bin/run-... script,
	 since /boot is mounted from a fresh copy of the original boot drive,
	 and thus quitting the vm and re-running the script will boot the
	 original system (before any deploys). However, the changes outside of
         /boot will survive!
# Past here is not tested :-P
5. ???
6. PROFIT!!!
