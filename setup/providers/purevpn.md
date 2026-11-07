# PureVPN

## TLDR

```sh
docker run -it --rm --cap-add=NET_ADMIN --device /dev/net/tun \
-e VPN_SERVICE_PROVIDER=purevpn \
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
      - VPN_SERVICE_PROVIDER=purevpn
      - OPENVPN_USER=abc
      - OPENVPN_PASSWORD=abc
      - SERVER_COUNTRIES=Netherlands
```

💁 To use with Wireguard, see [the custom provider Wireguard section](custom.md#wireguard).

## Required environment variables

- `VPN_SERVICE_PROVIDER=purevpn`
- `OPENVPN_USER`
- `OPENVPN_PASSWORD`

## Optional environment variables

- `SERVER_COUNTRIES`: Comma separated list of countries
- `SERVER_REGIONS`: Comma separated list of regions
- `SERVER_CITIES`: Comma separated list of cities
- `SERVER_CATEGORIES`: Comma separated list of server categories. Servers matching any of the values set are kept.
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames. Beware this is the narrowest filter, so if you set this to a single hostname and this hostname disappears from the Gluetun servers data due to an update, your container will no longer work until this filter is changed. I would suggest avoiding it unless you know this reliability risk.
- `PORT_FORWARD_ONLY`: Set to `true` to select servers supporting port forwarding only. Gluetun does not set up the forwarded port with PureVPN, so you have to enable port forwarding outside of Gluetun, for example on the PureVPN website.
- `OPENVPN_PROTOCOL`: `udp` or `tcp`, defaults to `udp`
- `OPENVPN_ENDPOINT_PORT`: Custom OpenVPN server port. Servers which do not list this port for the protocol selected are skipped.

## Ports

Gluetun tries every port a server lists for the OpenVPN protocol selected, unless `OPENVPN_ENDPOINT_PORT` is set.
If a server lists no port, Gluetun uses port `80` for TCP and port `15021` for UDP.


## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
