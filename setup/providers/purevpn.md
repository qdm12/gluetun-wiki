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
- `SERVER_CITIES`: Comma separated list of cities
- `SERVER_TYPES`: Comma separated list of server type tags. For PureVPN, this can include values such as `p2p`, `obfuscation`, `quantumresistant`, and `portforwarding`. Servers must match all values set.
- `SERVER_CATEGORIES`: Comma separated list of server category tags. Servers must match all values set.
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames. Beware this is the narrowest filter, so if you set this to a single hostname and this hostname disappears from the Gluetun servers data due to an update, your container will no longer work until this filter is changed. I would suggest avoiding it unless you know this reliability risk.

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
