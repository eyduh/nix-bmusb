{
  description = "A flake for bmusb by Sesse";

  inputs = {       
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";    
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    }; 
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        baseDependencies = with pkgs; [
          libusb1.dev
          pkg-config
        ];
        bmusb = (with pkgs; stdenv.mkDerivation {
          pname = "bmusb";
          version = "0.7.6";
          src = fetchgit {
            url = "http://git.sesse.net/bmusb";
            rev = "6334dc3fcbd67a757f6065a946a2343185c233fc";
            sha256 = "sha256-bK/VaszIzayjft6wIjuhdw78NsBO+N27hSED/4OJT78=";
          };
          buildInputs = baseDependencies;
          #buildPhase = "make -j $NIX_BUILD_CORES";
          installPhase = ''
            runHook preInstall
            mkdir -p $out/usr/local/lib/pkgconfig \
            mkdir -p $out/usr/local/include/bmusb \
            mkdir -p $out/lib/udev/rules.d
          '';
        }
      );
      in rec {
        apps.default = flake-utils.lib.mkApp {
          drv = packages.default;
        };
        packages.default = bmusb;
        devShells.default = pkgs.mkShell {
          buildInputs = [
            baseDependencies
          ];
        };
      }
    );
}
