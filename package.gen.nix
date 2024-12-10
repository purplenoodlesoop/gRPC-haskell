{ mkDerivation, async, base, bytestring, criterion
, grpc-haskell-core, lib, managed, proto3-suite, proto3-wire
, random
}:
mkDerivation {
  pname = "grpc-haskell";
  version = "0.4.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    async base bytestring grpc-haskell-core managed proto3-suite
    proto3-wire
  ];
  benchmarkHaskellDepends = [
    async base bytestring criterion proto3-suite random
  ];
  homepage = "https://github.com/awakenetworks/gRPC-haskell";
  description = "Haskell implementation of gRPC layered on shared C library";
  license = lib.licenses.asl20;
}
