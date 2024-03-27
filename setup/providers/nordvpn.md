# NordVPN

## TLDR

```sh
# OpenVPN
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=nordvpn \
-e OPENVPN_USER=abc -e OPENVPN_PASSWORD=abc \
-e SERVER_COUNTRIES=Netherlands qmcgaw/gluetun
```

💁 Your credentials are NO LONGER your email+password, it is now your service credentials.

```sh
# Wireguard
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=nordvpn \
-e VPN_TYPE=wireguard \
-e WIREGUARD_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU= \
-e SERVER_COUNTRIES=Netherlands qmcgaw/gluetun
```

[▶️ obtain your Wireguard private key](#obtain-your-wireguard-private-key)

```yml
version: "3"
services:
  gluetun:
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    environment:
      - VPN_SERVICE_PROVIDER=nordvpn
      - VPN_TYPE=openvpn # or wireguard
      - OPENVPN_USER=abc
      - OPENVPN_PASSWORD=abc
      - SERVER_COUNTRIES=Netherlands
```

## Required environment variables

- `VPN_SERVICE_PROVIDER=nordvpn`

### OpenVPN only

- `OPENVPN_USER`
- `OPENVPN_PASSWORD`

### Wireguard only

- `WIREGUARD_PRIVATE_KEY`

## Optional environment variables

- `SERVER_COUNTRIES`: Comma separated list of countries
- `SERVER_REGIONS`: Comma separated list of regions
- `SERVER_CITIES`: Comma separated list of server cities
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames
- `SERVER_CATEGORIES`: Comma separated list of server categories

## Obtain your Wireguard private key

Update 2023-09-24: you need to retrieve it from their web interface in manual setup section, see [this comment](https://github.com/qdm12/gluetun-wiki/issues/15).

## Servers

The list of servers for NordVPN is available in the [source code](https://github.com/qdm12/gluetun/blob/master/internal/storage/servers.json).

The table of servers cannot be put here unfortunately as there are too many servers and the Github markdown engine then fails.
