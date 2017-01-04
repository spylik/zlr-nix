{ pkgs ? import <nixpkgs> {} }:

let
    fetchgit = pkgs.fetchgit;
    make = pkgs.make;
    erlang = pkgs.erlang;
    perl = pkgs.perl;
    git = pkgs.git;

in rec {
    zlr = pkgs.stdenv.mkDerivation {
        # package name
        name ="zlr-0.0.1";
    
        # fetch fromg git
        src = fetchgit {
            url = "https://github.com/spylik/zlr";
            rev = "5cff4de38b1355174a89c7a81a0b5f1017144069";
            sha256 = "0mlnqnh1zbjvamfqxwj96aqf7iqgsc251lckh97p8mhxip5vhv3g";
        };

        # we requeired following package to perform build
        buildInputs = [
            erlang
            perl
            git
        ];

        # let's build the sources
        buildPhase = ''
            unset SSL_CERT_FILE     # dirty hack for development (https://github.com/NixOS/nixpkgs/issues/13744)
            make
        '';

        # copy release into $out
        installPhase = ''
            mkdir -p $out
            cp -r ./_rel/zlr/* $out/
        '';
    };
}
