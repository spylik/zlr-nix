{config, pkgs, ...}:

let 
    # we going to build zlr package from package.nix
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
            pkgs.gawk               # startup script generated by relx requered awk
            pkgs.gnused             # startup script generated by relx required sed
            pkgs.gzip               # startup script generated by relx required gzip (to archive/unarchive versions for hot-code reload)
            pkgs.utillinux          # startup script generated by relx required logger what in utillinux package
        ];

        description = "Zalora web service.";
        
        # we put service to multi-user.target it is kind of 3rd runlevel (multi-user, non-graphical)
        wantedBy = [ "multi-user.target" ];

        # todo: still need investigate why we do not able to run it from zlr user
#        serviceConfig.User = "zlr";
        serviceConfig.User = "root";
        serviceConfig.Group = "zlr";

        # our startap script generated by relx requre forking strategy
        serviceConfig.Type = "forking";

        # we will run this service after systemd network.target
        after = [ "network.target" ];

        # start command
        serviceConfig.ExecStart = ''${zlr}/bin/zlr start'';

        # enabling service
        enable = true;
    };
}
