{ stdenv, fetchgit, erlang, perl, git}:

stdenv.mkDerivation rec {
    # package name
    name = "zlr" + "_" + version;
    
    version = "5cff4de"; # we will use version tags here in the future instead of commit_id
    
    # fetch fromg git
    src = fetchgit {
        url = "https://github.com/spylik/zlr";
        rev = version;
        sha256 = "0mlnqnh1zbjvamfqxwj96aqf7iqgsc251lckh97p8mhxip5vhv3g";
    };

    # we requeired following package to perform build
    buildInputs = [
        erlang      # need erlang
        git         # we need git becouse we need to fetch internal dependencies (defined in Makefile).
        perl        # some internal deps from Makefile required perl
    ];

    # let's build the sources
    buildPhase = ''
        unset SSL_CERT_FILE     # dirty hack for development (https://github.com/NixOS/nixpkgs/issues/13744).  we do this hack becouse erlang.mk fetch some internal dependencies with curl but in default enviroment nix set nocert
        make
    '';

    # copy release into $out
    installPhase = ''
        mkdir -p $out
        cp -r ./_rel/zlr/* $out/        # going to copy compiled release by relx from _rel to the package $out
        ln -sfn /var/log/zlr $out/log   # relx by default perfom logging in current release directory to the log folder. nix package folder is r/o, so we can catchup with relx and redefine log folder or just make symlink to the service-user home folder what will be writable (we going to create user and home folder in module.nix)
    '';
}
