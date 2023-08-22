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
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames

## Obtain your Wireguard private key

Your Wireguard private key is valid for your account and all NordVPN servers, so you only have to extract it once. @bubuntux has written a Docker image to this

1. Login to your NordVPN account on their website
2. Create an access token, for example `abcxyz`
3. Run the following command:

  ```sh
  docker run --rm --cap-add=NET_ADMIN \
    -e TOKEN='abcxyz' ghcr.io/bubuntux/nordvpn:get_private_key
  ```

  This should output your private key which you can then set in Gluetun with `WIREGUARD_PRIVATE_KEY`

## Servers

The list of servers for NordVPN is available in the [source code](https://github.com/qdm12/gluetun/blob/master/internal/storage/servers.json).

The table of servers cannot be put here unfortunately as there are too many servers and the Github markdown engine then fails.
