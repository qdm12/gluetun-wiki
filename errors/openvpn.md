# OpenVPN common errors

## Interrupted system call

It may happen, quite rarely though, that Openvpn is killed in a loop by the host system.

Even if it runs in a container, because it shares the tunnel device with the host, the host can make it fail.

If you get regularly in your logs

```s
openvpn: Sun May 10 19:23:37 2020 Initialization Sequence Completed
openvpn: Sun May 10 19:23:45 2020 event_wait : Interrupted system call (code=4)
openvpn: Sun May 10 19:23:45 2020 ERROR: Linux route delete command failed: external program exited with error status: 2
openvpn: signal: killed
```

It might be another app you have interfering with the `/dev/net/tun` device and thus killing openvpn.

For QNAP users, it may be the **QCenter**. More information on [this issue](https://github.com/qdm12/gluetun/issues/157) and many thanks for @AlexAlbright for finding the root cause through trial and error 🎈
