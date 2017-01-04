{config, pkgs, ...}:

let 
    # extend packages with our own package
    extpkg = pkgs.callPackage ./package.nix {};
in

{
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
        description = "Zalora web service.";
         
        wantedBy = [ "multi-user.target" ];

        serviceConfig.User = "zlr";

        after = [ "network.target" ];
        serviceConfig.ExecStart = ''${extpkg.zlr}/bin/zlr start'';
    };
}
