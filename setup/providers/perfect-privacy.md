# Perfect Privacy

## TLDR

```sh
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER="perfect privacy" \
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
      - VPN_SERVICE_PROVIDER=perfect privacy
      - OPENVPN_USER=abc
      - OPENVPN_PASSWORD=abc
      - SERVER_CITIES=Amsterdam
```

⚠️ If you want to use DNS over TLS, disable the **TrackStop Filter for fraud** (see [this issue](https://github.com/qdm12/gluetun/issues/1479))

## Required environment variables

- `VPN_SERVICE_PROVIDER=perfect privacy`
- `OPENVPN_USER`
- `OPENVPN_PASSWORD`

## Optional environment variables

- `SERVER_CITIES`: Comma separated list of cities

## VPN server port forwarding

Set `VPN_PORT_FORWARDING=on` and the 3 ports forwarded will be logged out as well as available via the http control server.

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
