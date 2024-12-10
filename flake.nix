{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-grpc.url = "github:NixOS/nixpkgs?rev=d59a6c12647f8a31dda38599c2fde734ade198a8"; # gRPC 1.45.2
    core-flake = {
      url = "github:purplenoodlesoop/core-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { core-flake, nixpkgs-grpc, ... }:
    let
      name = "grpc-haskell";
      core = "core";
      genName = "package.gen.nix";
      coreName = "${name}-${core}";
      packages = {
        ${name} = ".";
        ${coreName} = core;
      };
      overlay = self: super: {
        inherit (import nixpkgs-grpc { inherit (self.pkgs) system; }) grpc;
        haskellPackages = super.haskellPackages.override {
          overrides =
            hSelf: hSuper:
            let
              call = name: hSelf.callPackage ./${packages.${name}}/${genName};
            in
            builtins.mapAttrs call {
              ${coreName} = {
                gpr = self.grpc;
              };
              ${name} = { };
            };
        };
      };
    in
    with core-flake;
    lib.evalFlake {
      overlays = [ overlay ];

      perSystem =
        { pkgs, lib, ... }:
        {
          imports = with nixosModules; [
            tasks
          ];

          flake = with pkgs; {
            shell = [
              haskellPackages.cabal2nix
            ];

            packages = builtins.mapAttrs (name: _: haskellPackages.${name}) packages;
          };

          tasks.gen = lib.map (name: "cd ${name}; cabal2nix . > ${genName} ") (builtins.attrValues packages);
        };

      topLevel.overlays.default = overlay;
    };
}
