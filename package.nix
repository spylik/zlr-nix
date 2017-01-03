{stdenv, fetchgit}:

zlr = stdenv.mkDerivation (rec {
    # package name
    name ="zlr-0.0.1";
    
    # fetch fromg git
    src = fetchgit {
        url = "https://github.com/spylik/zlr";
        rev = "8e3403f403e65647200583968fe835478dfeda5c";
    };

    # we requeired following package to perform build
    buildInputs = [
        erlang
    ];
    builder = builtins.toFile "builder.sh" "
        echo abrakadabra
        make
    ";
})
