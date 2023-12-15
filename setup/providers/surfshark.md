# Surfshark

## WireGuard

## How to obtain your WireGuard connection details

- Log into your SurfShark account
- Select VPN from the left menu and then `Manual Setup`
- Select `Deskop or mobile`
- Choose `WireGuard`
- Select `I don't have a keypair` and enter a name for the key (this can be anything)
- Click `Generate a new keypair`
- Make note of the `Private key`
- Next select a location and download the config file (Ignore the information on screen as it will not work with GlueTUN)
- Within the config file obtain the IP on the `Address` line this is used for the `WIREGUARD_ADDRESSES` to connect.

### docker run

```sh
# Wireguard
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=surfshark \
-e VPN_TYPE=wireguard \
-e WIREGUARD_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU= \
-e WIREGUARD_ADDRESSES="10.64.222.21/16" \
-e SERVER_COUNTRIES=Netherlands qmcgaw/gluetun
```

### docker compose

```yml
version: "3"
services:
  gluetun:
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    environment:
      - VPN_SERVICE_PROVIDER=surfshark
      - VPN_TYPE=wireguard
      - WIREGUARD_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU=
      - WIREGUARD_ADDRESSES=10.64.222.21/16
      - SERVER_COUNTRIES=Netherlands
```

### WireGuard required environment variables

- `VPN_SERVICE_PROVIDER=surfshark`
- `WIREGUARD_PRIVATE_KEY=your-private-key`
- `WIREGUARD_ADDRESSES=ip-from-config-file`

## OpenVPN

### docker run

```sh
# OpenVPN
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=surfshark \
-e OPENVPN_USER=abc -e OPENVPN_PASSWORD=abc \
-e SERVER_COUNTRIES=Netherlands qmcgaw/gluetun
```

### Open VPN required environment variables

- `VPN_SERVICE_PROVIDER=surfshark`
- `OPENVPN_USER`
- `OPENVPN_PASSWORD`

## Optional environment variables

- `VPN_TYPE`: `openvpn` or `wireguard`
- `SERVER_COUNTRIES`: Comma separated list of countries
- `SERVER_REGIONS`: Comma separated list of regions
- `SERVER_CITIES`: Comma separated list of cities
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
