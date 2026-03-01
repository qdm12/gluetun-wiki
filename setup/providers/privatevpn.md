# PrivateVPN

## TLDR

💁 To use with Wireguard, see [the custom provider Wireguard section](custom.md#wireguard).

For OpenVPN:

```sh
docker run -it --rm --cap-add=NET_ADMIN --device /dev/net/tun \
-e VPN_SERVICE_PROVIDER=privatevpn \
-e OPENVPN_USER=abc -e OPENVPN_PASSWORD=abc \
-e SERVER_COUNTRIES=Netherlands qmcgaw/gluetun
```

```yml
version: "3"
services:
  gluetun:
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun:/dev/net/tun
    environment:
      - VPN_SERVICE_PROVIDER=privatevpn
      - OPENVPN_USER=abc
      - OPENVPN_PASSWORD=abc
      - SERVER_COUNTRIES=Netherlands
```

## Required environment variables

- `VPN_SERVICE_PROVIDER=privatevpn`
- `OPENVPN_USER`: Your PrivateVPN account login, not the "Proxy login" found on its Control Panel
- `OPENVPN_PASSWORD`: Your PrivateVPN account password

## Optional environment variables

- `SERVER_COUNTRIES`: Comma separated list of countries
- `SERVER_CITIES`: Comma separated list of cities
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames. Beware this is the narrowest filter, so if you set this to a single hostname and this hostname disappears from the Gluetun servers data due to an update, your container will no longer work until this filter is changed. I would suggest avoiding it unless you know this reliability risk.
- `OPENVPN_ENDPOINT_PORT`: Custom OpenVPN server endpoint port to use
- `OPENVPN_PROTOCOL`: `udp` or `tcp`, defaults to `udp`

## VPN server port forwarding

VPN server port forwarding is only supported on OpenVPN. If you try using it with Wireguard, PrivateVPN API will return `{"supported":false}` message, resulting in a "port forwarding not supported for this VPN server" error.

Set `VPN_PORT_FORWARDING=on` and the port forwarded will be logged out as well as available via the http control server. See [VPN server port forwarding setup page](../advanced/vpn-port-forwarding.md) for more details.

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
