# SPDX-FileCopyrightText: 2020 Serokell <https://serokell.io/>
#
# SPDX-License-Identifier: MPL-2.0

{
  description = "Deploy a full system with hello service as a separate profile";

  inputs.deploy-rs.url = "github:serokell/deploy-rs";
  inputs.nixpkgs.follows = "deploy-rs/nixpkgs";

  outputs = { self, nixpkgs, deploy-rs }: {
    nixosConfigurations.example-nixos-system = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };

    nixosConfigurations.bare = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ ./bare.nix "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix" ];
    };

    # This is the application we actually want to run
    defaultPackage.x86_64-linux = import ./hello.nix nixpkgs;

    deploy.nodes.example = {
      sshOpts = [ "-p" "2221" "-o" "UserKnownHostsFile=/dev/null" "-o" "StrictHostKeyChecking=no" ];
      hostname = "localhost";
      fastConnection = true;
      profilesOrder = ["system" "hello"]; # unfortunately, this is not strong enough: we copy system, then copy hello, but at that point (from a bare machine), the 'hello' user does not exist, so the copy fails!
      profiles = {
        system = {
          sshUser = "admin";
          path =
            deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.example-nixos-system;
          user = "root";
        };
        hello = {
          sshUser = "hello";
          path = deploy-rs.lib.x86_64-linux.activate.custom self.defaultPackage.x86_64-linux "./bin/activate";
          user = "hello";
        };
      };
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

    # use the pinned deploy-rs, via 'nix run .' (or nix develop, then run deploy-rs)
    apps.x86_64-linux.deployApp = {
      type = "app";
      program = "${deploy-rs.packages.x86_64-linux.deploy-rs}/bin/deploy";
    };
    defaultApp.x86_64-linux = self.apps.x86_64-linux.deployApp;

    devShell.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.mkShell {
       buildInputs = [ deploy-rs.defaultPackage.x86_64-linux ];
    };
  };
}
