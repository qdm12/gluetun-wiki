# Firewall common errors

The firewall right now is managed by `iptables` (`iptables-nft` preferred, and falls back on `iptables-legacy`) and `ip6tables` (`ip6tables-nft` preferred, and falls back on `ip6tables-legacy`). Some common errors with their resolution are listed below.

## `Table does not exist (do you need to insmod?)`

### Raspberry Pis

This is common on Raspberry Pis.

If you encounter the error:

```log
iptables v1.8.10 (nf_tables): can't initialize iptables table `filter': Table does not exist (do you need to insmod?)
```

You likely need to update your system with `rpi-update`, see [#400](https://github.com/qdm12/gluetun/issues/400) for more information.

### Podman

Podman might need the extra capability `NET_RAW` added to Gluetun, on top of `NET_ADMIN`.

## `Permission denied (you must be root)`

If you use Portainer to run the container and get the error:

```log
2020-05-03T09:04:11.283Z ERROR failed executing "-P INPUT ACCEPT": iptables v1.8.10 (nf_tables): can't initialize iptables table `filter': Permission denied (you must be root)
Perhaps iptables or your kernel needs to be upgraded.: exit status 3
```

This might be because Portainer does not set the `--cap_add=NET_ADMIN` successfully.

You might need to run the container without Portainer in this case. More information on [#139](https://github.com/qdm12/gluetun/issues/139).
