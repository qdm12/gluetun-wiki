# WeVPN

## TLDR

💁 To use with Wireguard, see [the custom provider Wireguard section](custom.md#wireguard).

First, [setup your client key](../advanced/openvpn-client-key.md). Then you can use:

```sh
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=wevpn \
-e OPENVPN_USER=abc -e OPENVPN_PASSWORD=abc \
-e SERVER_CITIES=Amsterdam qmcgaw/gluetun
```

```yml
version: "3"
services:
  gluetun:
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    environment:
      - VPN_SERVICE_PROVIDER=wevpn
      - OPENVPN_USER=abc
      - OPENVPN_PASSWORD=abc
      - SERVER_CITIES=Amsterdam
```

## Required environment variables

- `VPN_SERVICE_PROVIDER=wevpn`
- `OPENVPN_USER`
- `OPENVPN_PASSWORD`

## Optional environment variables

- `SERVER_CITIES`: Comma separated list of cities
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames
- `VPN_ENDPOINT_PORT`: Custom OpenVPN server endpoint port
  - For TCP: `53`, `1195`, `1199` or `2018`
  - For UDP: `80`, `1194` or `1198`

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
