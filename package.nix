{ stdenv, fetchgit, erlang, perl, git}:

with stdenv.lib;    # for able use license.* platforms.*, etc

stdenv.mkDerivation rec {
    # package name
    name = "zlr-${version}";

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
        git         # we need git because we need to fetch internal dependencies (defined in Makefile).
        perl        # some internal deps from Makefile required perl
    ];

    # let's build the sources
    buildPhase = ''
        # set SSL_CERT_FILE cuz git and curl in erlang.mk required it
        export SSL_CERT_FILE="/etc/ssl/certs/ca-bundle.crt"
        make
    '';

    # copy release into $out and create symlink for logs
    installPhase = ''
        mkdir -p $out
        cp -r ./_rel/zlr/* $out/        # Going to copy compiled release by relx from _rel to the package $out
        ln -sfn /var/log/zlr $out/log   # Relx by default perfom logging in current release directory to the
                                        # $project_release/log folder. We can create different
                                        # production/development/testing enviroment where we can redefine how we log,
                                        # or we can (current solution) just create symlink to the service-user-home
                                        # folder what will only keep logs and will be writable by the zlr service
                                        # system user.
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
