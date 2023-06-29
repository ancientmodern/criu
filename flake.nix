# SPDX-FileCopyrightText: Copyright (c) 2023 by Rivos Inc.
# SPDX-License-Identifier: MIT
{
  description = "criu (rivos fork)";

  nixConfig = {
    extra-substituters = ["https://nix-cache.ext.rivosinc.com/external"];
    extra-trusted-public-keys = ["external:oqiV+OxD669ldyKWKV3dNxIMAqokyD7CH+fFSMSZ604="];
  };

  inputs = {
    nixpkgs.url = "github:rivosinc/nixpkgs/rivos/nixos-22.11?allRefs=true";
    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks-nix.url = "github:cachix/pre-commit-hooks.nix";
    linux = {
      url = "git+ssh://git@gitlab.ba.rivosinc.com/rv/sw/ext/linux.git?ref=dev/haorong/ptrace_upai_orig_a0";
      flake = false;
    };

    crosspkgs.url = "github:rivosinc/crosspkgs";
    crosspkgs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    crosspkgs,
    nixpkgs,
    flake-parts,
    self,
    ...
  }:
  let
    lib = nixpkgs.lib;
    # TODO: don't hardcode.
    criuMajor = "3";
    criuMinor = "18";
    version = "${criuMajor}.${criuMinor}-g${self.shortRev or "dirty"}";
  in
    flake-parts.lib.mkFlake {inherit inputs;}
    {
      imports = [
        crosspkgs.flakeModules.default
        flake-parts.flakeModules.easyOverlay
      ];
      perSystem = {
        final,
        pkgs,
        inputs',
        lib,
        ...
      }: rec {
        packages = rec {
          linuxHeaders = pkgs.makeLinuxHeaders {
            version = "6.4.0";
            src = inputs.linux;
          };
          criu = final.callPackage ./rivos/nix {
            inherit version;
            src = self;
          };
          default = criu;
        };
        overlayAttrs = packages;
      };
    };
}
