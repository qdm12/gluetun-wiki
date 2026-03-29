# AzireVPN

## TLDR

```sh
# Wireguard
docker run -it --rm --cap-add=NET_ADMIN --device /dev/net/tun \
-e VPN_SERVICE_PROVIDER=azirevpn \
-e VPN_TYPE=wireguard \
-e WIREGUARD_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU= \
-e AZIREVPN_TOKEN=your_api_token \
-e SERVER_COUNTRIES=Sweden qmcgaw/gluetun
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
      - VPN_SERVICE_PROVIDER=azirevpn
      - VPN_TYPE=wireguard
      - WIREGUARD_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU=
      - AZIREVPN_TOKEN=your_api_token
      - SERVER_COUNTRIES=Sweden
```

## Required environment variables

- `VPN_SERVICE_PROVIDER=azirevpn`
- `VPN_TYPE=wireguard`
- `WIREGUARD_PRIVATE_KEY` is your 32-byte key in base64 format
- `WIREGUARD_ADDRESSES` is your WireGuard interface address(es) in CIDR format

## Optional environment variables

- `SERVER_COUNTRIES`: Comma separated list of countries
- `SERVER_CITIES`: Comma separated list of cities
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames
- `SERVER_NAMES`: Comma separated list of server names
- `PORT_FORWARD_ONLY`: Filter to servers supporting port forwarding
- `OWNED_ONLY`: Filter to owned servers only
- `VPN_PORT_FORWARDING`: defaults to `off` and can be set to `on`
- `AZIREVPN_TOKEN`: required only if `VPN_PORT_FORWARDING=on`

## VPN server port forwarding

Requirements:

- `VPN_PORT_FORWARDING=on`
- Active VPN tunnel connection (AzireVPN requires this for port forwarding API endpoints)

AzireVPN will assign and maintain a forwarded port through their API integration in Gluetun.
See [vpn port forwarding options](../advanced/vpn-port-forwarding.md) for ways to access and use the forwarded port.

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
