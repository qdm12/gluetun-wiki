# OpenVPN common errors

## Inconsistence warnings

You might see some warnings for Private Internet Access and others, similar to:

```s
openvpn: Sat Feb 22 15:55:02 2020 WARNING: 'link-mtu' is used inconsistently, local='link-mtu 1569', remote='link-mtu 1542'
openvpn: Sat Feb 22 15:55:02 2020 WARNING: 'cipher' is used inconsistently, local='cipher AES-256-CBC', remote='cipher BF-CBC'
openvpn: Sat Feb 22 15:55:02 2020 WARNING: 'auth' is used inconsistently, local='auth SHA256', remote='auth SHA1'
openvpn: Sat Feb 22 15:55:02 2020 WARNING: 'keysize' is used inconsistently, local='keysize 256', remote='keysize 128'
openvpn: Sat Feb 22 15:55:02 2020 WARNING: 'comp-lzo' is present in remote config but missing in local config, remote='comp-lzo'
```

It is mainly because the option [disable-occ](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-4/) was removed for transparency with you.

Private Internet Access explains [here why](https://www.privateinternetaccess.com/helpdesk/kb/articles/why-do-i-get-cipher-auth-warnings-when-i-connect) the warnings show up.

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
