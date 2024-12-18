# OpenVPN configuration file

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.setup.openvpn-file)

You can use an Openvpn configuration file instead of using the built in providers.

## Warnings

- There is some [implicit behavior](#implicit-behavior) that you should be aware of.
- If you encounter any issue, please first [open a discussion](https://github.com/qdm12/gluetun/discussions/new) and then, if it's a valid issue, [open an issue](https://github.com/qdm12/gluetun/issues/new/choose).
- My support will be limited from my part as I can't help everyone with VPN providers or private VPN servers I am not familiar with.
- If you want a smooth experience, [create an issue to support a new provider](https://github.com/qdm12/gluetun/issues/new?assignees=&labels=%3Abulb%3A+New+provider&template=provider.md&title=VPN+provider+support%3A+NAME+OF+THE+PROVIDER), it usually takes 2 to 4 weeks to implement it.

## Setup

In the following we assume your custom openvpn configuration file is named `custom.conf`. Note this can be named something else, for example `autralia.ovpn`.

1. Replace the VPN server hostname by one of its IP addresses. In `custom.conf`, find the line starting with `remote`. The second field is the VPN server hostname. If it is not an IP address, you need to DNS resolve it, for example with `nslookup domain.com` and replace the hostname field with one of its corresponding IP addresses. This is the case as gluetun's firewall is designed not to leak anything including an initial DNS resolution when starting.
1. Bind mount your `custom.conf` file to `/gluetun/custom.conf`. If you have other files such as `ca.crt` or `up.sh`, bind mount them to `/gluetun/` as well.
1. If you have other files referenced in your `custom.conf` such as `ca ca.crt` or `up up.sh`, change the paths to be absolute such as `ca /gluetun/ca.crt` and `up /gluetun/up.sh`. This is because your configuration file `custom.conf` is read, parsed, modified and written somewhere else at runtime.
1. Set the environment variables:
    - `VPN_SERVICE_PROVIDER=custom`
    - `OPENVPN_CUSTOM_CONFIG=/gluetun/custom.conf`
1. The environment variables `OPENVPN_USER` and `OPENVPN_PASSWORD` are not enforced but should be set if you use authentication.
1. Run the container for example with:

    ```sh
    docker run -it --rm --cap-add=NET_ADMIN --device /dev/net/tun -e VPN_SERVICE_PROVIDER=custom -e OPENVPN_CUSTOM_CONFIG=/gluetun/custom.conf -v /yourpath/custom.conf:/gluetun/custom.conf:ro -e OPENVPN_USER="youruser" -e OPENVPN_PASSWORD="yourpassword" qmcgaw/gluetun
    ```

## Implicit behavior

### Relative file paths

Files referenced in your OpenVPN configuration file as relative file paths will not work.
This is because your configuration file is read, parsed, modified and rewritten to `/etc/openvpn/target.ovpn` (subject to change). You could however adapt these file paths to match that directory, or use absolute paths.

### Multiple remote options

If you have multiple `remote` instructions, only the first one is taken into account.

### Added options

Gluetun adds or overrides the following options:

```conf
mute-replay-warnings
suppress-timestamps
auth-nocache
auth-retry nointeract
auth-user-pass /etc/openvpn/auth.conf
pull-filter ignore "auth-token"
```

### Environment variables

#### Options overridden

- `OPENVPN_VERBOSITY` defaults to `1` and adds or overrides the `verb` option.
- `VPN_INTERFACE` defaults to `tun0` and adds or overrides the `dev` option.
- If `OPENVPN_PROCESS_USER=root` (default), the `user` options is removed so OpenVPN runs as root.
Otherwise, `user ${OPENVPN_PROCESS_USER}` option is added or overridden.
- If IPv6 is not supported, the following options are added:

    ```conf
    pull-filter ignore "route-ipv6"
    pull-filter ignore "ifconfig-ipv6"
    ```

    And the `tun-ipv6` option is removed.

#### Options overridden if variables are set

- `OPENVPN_CIPHERS`, if set, adds or overrides `data-ciphers` and `data-ciphers-fallback`
- `OPENVPN_AUTH`, if set, adds or overrides `auth`.
- `OPENVPN_MSSFIX`, if set, adds or overrides `mssfix`.
- `OPENVPN_ENDPOINT_PORT`, if set, overrides the port of the remote connection found in the file.

#### Ignored variables

The following OpenVPN environment variables have no effect:

- `OPENVPN_PROTOCOL` - the protocol is determined from your configuration file only.
- `OPENVPN_CLIENTKEY_SECRETFILE`
- `OPENVPN_CLIENTCRT_SECRETFILE`
- `OPENVPN_ENCRYPTED_KEY_SECRETFILE`
- `OPENVPN_KEY_PASSHPRASE_SECRETFILE`
- `OPENVPN_ENDPOINT_IP`
