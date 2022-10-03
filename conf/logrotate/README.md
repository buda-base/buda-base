# Logrotate Configuration

Create an aws profile `budabackup` accessible to root and copy these files to `/etc/logrotate.d/`.

In `/lib/systemd/system/logrotate.service`:

Comment

```
ProtectSystem=full
```

(or move the logs to `/var/log/` which is not protected in logrotate)

and run

`systemctl daemon-reload && systemctl start logrotate`
