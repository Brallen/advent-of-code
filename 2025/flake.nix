{
  description = "A Haskell development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        haskellPackages = pkgs.haskellPackages;
        
        projectName = "advent-of-code-2025";
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with haskellPackages; [
            ghc
            cabal-install
            haskell-language-server
            fourmolu
            hlint
          ];

          shellHook = ''
            echo "Haskell development environment"
            echo "GHC version: $(ghc --version)"
            echo "Cabal version: $(cabal --version | head -n 1)"
            echo ""
            echo "Available commands:"
            echo "  cabal init          - Initialize a new project"
            echo "  cabal build         - Build the project"
            echo "  cabal run           - Run the executable"
            echo "  fourmolu -i <file>  - Format a file"
            echo "  hlint <file>        - Lint a file"
          '';
        };
      }
    );
}
