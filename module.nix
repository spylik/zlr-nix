{config, pkgs, ...}:

let 
    # extend packages with our own package
    extpkg = pkgs.callPackage ./package.nix {};
in

{
    # creating system.d service
    systemd.services.zaloraWWW = {
        description = "Start zalora web service.";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig.ExecStart = ''${extpkg.zlr}/bin/zlr start'';
    };
}
