{ mkDerivation, async, base, bytestring, c2hs, clock, containers
, gpr, grpc, lib, managed, pipes, proto3-suite, QuickCheck, safe
, stm, tasty, tasty-hunit, tasty-quickcheck, template-haskell, text
, time, transformers, turtle, unix
}:
mkDerivation {
  pname = "grpc-haskell-core";
  version = "0.6.0";
  src = ./.;
  libraryHaskellDepends = [
    base bytestring clock containers managed stm template-haskell
    transformers
  ];
  librarySystemDepends = [ gpr grpc ];
  libraryToolDepends = [ c2hs ];
  testHaskellDepends = [
    async base bytestring clock containers managed pipes proto3-suite
    QuickCheck safe tasty tasty-hunit tasty-quickcheck text time
    transformers turtle unix
  ];
  homepage = "https://github.com/awakenetworks/gRPC-haskell";
  description = "Haskell implementation of gRPC layered on shared C library";
  license = lib.licenses.asl20;
}
