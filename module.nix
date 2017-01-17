{config, pkgs, ...}:

let 
    zlr = pkgs.callPackage ./package.nix {};
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
            pkgs.utillinux
        ];

        description = "Zalora web service.";
         
        wantedBy = [ "multi-user.target" ];

#        serviceConfig.User = "zlr";
        serviceConfig.User = "root";
        serviceConfig.Group = "zlr";
        serviceConfig.Type = "forking";

        after = [ "network.target" ];

        serviceConfig.ExecStart = ''${zlr}/bin/zlr start'';

        enable = true;
    };
}
