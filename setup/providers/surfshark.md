# Surfshark

## TLDR

```sh
# OpenVPN
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=surfshark \
-e OPENVPN_USER=abc -e OPENVPN_PASSWORD=abc \
-e SERVER_COUNTRIES=Netherlands qmcgaw/gluetun
```

```sh
# Wireguard
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=surfshark \
-e VPN_TYPE=wireguard \
-e WIREGUARD_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU= \
-e WIREGUARD_ADDRESSES="10.64.222.21/16" \
-e SERVER_COUNTRIES=Netherlands qmcgaw/gluetun
```

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

## Required environment variables

- `VPN_SERVICE_PROVIDER=surfshark`

### OpenVPN only

- `OPENVPN_USER` which you can find in VPN > Manual setup > Credentials
- `OPENVPN_PASSWORD` which you can find in VPN > Manual setup > Credentials

### Wireguard only

- `WIREGUARD_PRIVATE_KEY` is your 32 bytes key in base64 format. The private key can only be registered (and eventually generated) with these steps:
  1. Log into your Surfshark account
  1. Select *VPN* from the left menu
  1. Select *Manual Setup*
  1. Select *Deskop or mobile*
  1. Select *WireGuard*
  1. Select *I don't have a keypair* and enter a name for the key
  1. Select *Generate a new keypair*
  1. Use the **Private key** value for the `WIREGUARD_PRIVATE_KEY` environment variable
  1. Next select a location and download the config file (Ignore the information on screen as it will not work with GlueTUN)
  1. Within the config file obtain the IP on the `Address` line this is used for the `WIREGUARD_ADDRESSES` to connect.
- `WIREGUARD_ADDRESSES` is the Wireguard IP network interface address in CIDR format `xx.xx.xx.xx/xx`. To obtain it, first download a Wireguard configuration file using same steps as for `WIREGUARD_PRIVATE_KEY` above. In the configuration file, locate the `Address` value. This one should contain a comma delimited list of an IPv4 and IPv6 address, so use the IPv4 address (usually the first one) as the value for the `WIREGUARD_ADDRESSES` environment variable. You can add the IPv6 address if your setup supports IPv6. Note this is the same value for all Surfshark servers and for your private key.

## Optional environment variables

- `VPN_TYPE`: `openvpn` or `wireguard`
- `SERVER_COUNTRIES`: Comma separated list of countries
- `SERVER_REGIONS`: Comma separated list of regions
- `SERVER_CITIES`: Comma separated list of cities
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
