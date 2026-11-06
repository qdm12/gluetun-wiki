# VPN Unlimited

## TLDR

💁 To use with Wireguard, see [the custom provider Wireguard section](custom.md#wireguard)

For OpenVPN:

1. [Setup your client key](../advanced/openvpn-client-key.md)
1. [Setup your client certificate](../advanced/openvpn-client-certificate.md)

```sh
docker run -it --rm --cap-add=NET_ADMIN --device /dev/net/tun \
-e VPN_SERVICE_PROVIDER="vpn unlimited" \
-v /yourpath/gluetun:/gluetun \
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
      - VPN_SERVICE_PROVIDER=vpn unlimited
      - OPENVPN_USER=abc
      - OPENVPN_PASSWORD=abc
      - SERVER_COUNTRIES=Netherlands
    volumes:
      - ./gluetun:/gluetun
```

## Required environment variables

- `VPN_SERVICE_PROVIDER=vpn unlimited`
- `OPENVPN_USER`
- `OPENVPN_PASSWORD`

## Optional environment variables

- `SERVER_COUNTRIES`: Comma separated list of countries
- `SERVER_REGIONS`: Comma separated list of regions
- `SERVER_CITIES`: Comma separated list of cities
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames. Beware this is the narrowest filter, so if you set this to a single hostname and this hostname disappears from the Gluetun servers data due to an update, your container will no longer work until this filter is changed. I would suggest avoiding it unless you know this reliability risk.
- `OPENVPN_PROTOCOL`: `udp` or `tcp`, defaults to `udp`

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
