{config, pkgs, ...}:

{
    systemd.services.zaloraWWW = {
        description = "Start zalora web service.";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig.ExecStart = ''${pkgs.zlr}/_rel/zlr/bin/zlr start'';
    };
}
