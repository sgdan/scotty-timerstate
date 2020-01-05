FROM nixos/nix:2.3

# Install Cabal
RUN nix-env -f "<nixpkgs>" -iA haskellPackages.cabal-install
RUN nix-env -i curl
RUN cabal update

# Useful for updating default.nix when dependencies change
RUN nix-env -i cabal2nix

# Install dependencies as image layers
RUN nix-env -f "<nixpkgs>" -iA haskellPackages.ghc
RUN nix-env -f "<nixpkgs>" -iA haskellPackages.scotty
RUN nix-env -i bash-interactive glibc-locales diffutils ed gawk gnumake hook lndir patch patchelf
RUN nix-env -f "<nixpkgs>" -iA haskellPackages.suspend
RUN nix-env -f "<nixpkgs>" -iA haskellPackages.timers

# Run nix shell using dependencies from default.nix
# This will cache any dependencies missed above
WORKDIR /working
COPY scotty-timerstate.cabal .
COPY release.nix .
COPY default.nix .
RUN nix-shell --attr env release.nix --run 'cabal configure'
