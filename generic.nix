{config, pkgs, ...}:

let
    stdenv = pkgs.stdenv;
    zlr = stdenv.mkDerivation rec {
        
        # package name
        name ="zlr";
        
        # fetch fromg git
        src = pkgs.fetchgit {
            url = "https://github.com/spylik/zlr";
            rev = "8e3403f403e65647200583968fe835478dfeda5c";
        };

        # we requeired following package to perform build
        buildInputs = [
            pkgs.erlang
        ];
        builder = builtins.toFile "builder.sh" "make";
    };
in {
    systemd.services.zaloraWWW = {
        description = "Start zalora web service.";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig.ExecStart = ''${pkgs.zlr}/_rel/zlr/bin/zlr'';
    };
}
