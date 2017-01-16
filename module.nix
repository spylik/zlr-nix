{config, pkgs, ...}:

let 
    # extend packages with our own package
    extpkg = pkgs.callPackage ./package.nix {};
in

{

    # open port
    networking.firewall.allowedTCPPorts = [80];

    # Create separate group for zalora web service
    users.extraGroups.zlr = {};

    # Create separate user account for zalora web service
    users.extraUsers.zlr = {
        description = "Zalora web service user";
        home = "/var/log/zlr";
        createHome = true;
    };

    # creating system.d service for zalora web service
    systemd.services.zaloraWWW = {
        path = [
            pkgs.gawk
            pkgs.gnused
            pkgs.gzip
            pkgs.less
            pkgs.utillinux
        ];

        description = "Zalora web service.";
         
        wantedBy = [ "multi-user.target" ];

        serviceConfig.User = "zlr";
        serviceConfig.Type = "forking";

        after = [ "network.target" ];

        serviceConfig.ExecStart = ''${extpkg.zlr}/bin/zlr start'';
    };

    systemd.services.zaloraWWW.enable = true;
}
