{ pkgs ? import <nixpkgs> {} }:
let 
	stdenv = pkgs.stdenv;
	fetchgit = pkgs.build-support.fetchgit;
in rec {
	zlr-nix = stdenv.mkDerivation rec {
		name = "zlr-nix";
		src = fetchgit {
			url = "git://github.com/spylik/zlr.git";
			rev = "8e3403f403e65647200583968fe835478dfeda5c";
		};
		BuildInputs = [
			"pkgs.erlang-19.1.6"
		];
		builder = builtins.toFile "builder.sh" "make"; 
	};
}
