{ mkDerivation, aeson, base, base-compat, data-default-class, mtl
, scotty, stdenv, stm, suspend, text, timers, transformers
, wai-extra
}:
mkDerivation {
  pname = "scotty-timerstate";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson base base-compat data-default-class mtl scotty stm suspend
    text timers transformers wai-extra
  ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
