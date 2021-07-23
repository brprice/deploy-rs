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
2. `nix run . -- .#example.system`

# Past here is not yet tested
3. `nix run . -- .#example.hello`
4. ???
5. PROFIT!!!
