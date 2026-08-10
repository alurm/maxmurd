{ pkgs, ... }:
{
  systemd.user.services.maxmurd = {
    script = "NOTIFY=${pkgs.libnotify}/bin/notify-send ${./dick.sh}";
  };
  systemd.user.timers.maxmurd = {
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "2m";
      RandomizedDelaySec = "7m";
      AccuracySec = "1s";
    };
    wantedBy = [ "timers.target" ];
  };
}
