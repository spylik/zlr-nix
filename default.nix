{config, pkgs, ...}:

let
    stdenv = pkgs.stdenv;
    zlr-nix = stdenv.mkDerivation rec {
        
        # package name
        name ="zlr-nix";
        
        # fetch fromg git
        src = pkgs.fetchgit {
            url = "https://github.com/spylik/zlr";
            rev = "8e3403f403e65647200583968fe835478dfeda5c";
        };

        # we requeired following package for perform build
        buildInputs = [
            stdenv
            pkgs.erlang
        ];
        builder = builtins.toFile "builder.sh" "make";
    };
in
    with pkgs.lib;
{
}
