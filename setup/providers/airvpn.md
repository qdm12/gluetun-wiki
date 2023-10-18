# AirVPN

## Wireguard

1. [Generate and download your .conf file](https://airvpn.org/generator/) - Select WireGuard, continents and hit *Generate* at the bottom
1. Open the newly generated .conf file anad take note of the `[Interface] PrivateKey`, `[Peer] PresharedKey` and `[Interface] Address`
1. Launch docker image with:

```sh
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=airvpn \
  -e VPN_TYPE=wireguard \
  -e WIREGUARD_PRIVATE_KEY=PrivateKey goes here \
  -e WIREGUARD_PRESHARED_KEY=PresharedKey goes here \
  -e WIREGUARD_ADDRESSES=Address goes here (keep only the first IPv4 address 10..../32 unless have IPv6 working on Docker) \
  qmcgaw/gluetun
```

Or if using docker-compose.yml:

```yml
version: "3"
services:
  gluetun:
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    environment:
      - VPN_SERVICE_PROVIDER=airvpn
      - VPN_TYPE=wireguard
      - WIREGUARD_PRIVATE_KEY=PrivateKey goes here
      - WIREGUARD_PRESHARED_KEY=PresharedKey goes here
      - WIREGUARD_ADDRESSES=Address goes here (keep only the first IPv4 address 10..../32 unless have IPv6 working on Docker)
      - SERVER_COUNTRIES=Netherlands
```

## OpenVPN

1. [Setup your client key](../advanced/openvpn-client-key.md)
1. [Setup your client certificate](../advanced/openvpn-client-certificate.md)

```sh
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=airvpn \
  -v /yourpath:/gluetun \
  -e SERVER_COUNTRIES=Netherlands \
  qmcgaw/gluetun
```

```yml
version: "3"
services:
  gluetun:
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    environment:
      - VPN_SERVICE_PROVIDER=airvpn
      - SERVER_COUNTRIES=Netherlands
    volumes:
      - ./gluetun:/gluetun
```

## VPN port forwarding

If you want to use VPN server side port forwarding:

1. Log in your AirVPN account at [airvpn.org/client](https://airvpn.org/client/)
1. Obtain a port from [airvpn.org/ports](https://airvpn.org/ports/)
1. Add the port to the environment variable `FIREWALL_VPN_INPUT_PORTS`

## Required environment variables

- `VPN_SERVICE_PROVIDER=airvpn`
- For Wireguard:
  - `VPN_TYPE=wireguard`
  - `WIREGUARD_PRIVATE_KEY`
  - `WIREGUARD_PRESHARED_KEY`
  - `WIREGUARD_ADDRESSES`

## Optional environment variables

- `SERVER_COUNTRIES`: Comma separated list of countries
- `SERVER_REGIONS`: Comma separated list of regions
- `SERVER_CITIES`: Comma separated list of cities
- `SERVER_NAMES`: Comma separated list of server names
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames

## Servers

The list of servers for AirVPN is available in the [source code](https://github.com/qdm12/gluetun/blob/master/internal/storage/servers.json).

The table of servers cannot be put here unfortunately as there are too many servers and the Github markdown engine then fails.

