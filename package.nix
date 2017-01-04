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
            rev = "8e3403f403e65647200583968fe835478dfeda5c";
            sha256 = "0dc5pl775sz5m31a4qdggaw6nwi3k2irgd2gkq4zirhz4iklzkds";
        };

        # we requeired following package to perform build
        buildInputs = [
            erlang
            perl
            git
        ];

        # let's build the sources
        buildPhase = ''
            unset SSL_CERT_FILE     # dirty hack for development
            make
        '';
    };
}
