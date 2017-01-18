{ stdenv, fetchgit, erlang, perl, git}:

with stdenv.lib;    # for able use license.* platforms.*, etc

stdenv.mkDerivation rec {
    # package name
    name = "zlr" + "-" + version;

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

    # set SSL_CERT_FILE cuz git and curl in erlang.mk required it
    SSL_CERT_FILE="/etc/ssl/certs/ca-bundle.crt";

    # let's build the sources
    buildPhase = "make";

    # copy release into $out and create symlinc for logs
    installPhase = ''
        mkdir -p $out
        cp -r ./_rel/zlr/* $out/        # going to copy compiled release by relx from _rel to the package $out
        ln -sfn /var/log/zlr $out/log   # relx by default perfom logging in current release directory to the log folder. nix package folder is r/o, so we can catchup with relx and redefine log folder or just make symlink to the service-user home folder what will be writable (we going to create user and home folder in module.nix)
    '';
    
    # package meta information 
    meta = {
        description = "Simple erlang http application wrapped as nix package";
        longDescription = ''
            zlr - is a simple test erlang web application configured to run on port 80.
            It use cowboy (https://github.com/ninenines/cowboy) as web-server,
            erlang.mk as Makefile template and relx for release generation.
        '';
        homepage = "https://github.com/spylik/zlr";
        license = licenses.mit;
        platforms = platforms.unix;
    };
}
