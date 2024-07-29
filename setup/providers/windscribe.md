# Windscribe

## TLDR

```sh
# OpenVPN
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=windscribe \
-e VPN_TYPE=openvpn \
-e OPENVPN_USER=abc -e OPENVPN_PASSWORD=abc \
-e SERVER_REGIONS=Netherlands qmcgaw/gluetun
```

```sh
# Wireguard
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=windscribe \
-e VPN_TYPE=wireguard \
-e WIREGUARD_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU= \
-e WIREGUARD_ADDRESSES="10.64.222.21/32" \
-e WIREGUARD_PRESHARED_KEY= \
-e SERVER_REGIONS=Netherlands qmcgaw/gluetun
```

```yml
version: "3"
services:
  gluetun:
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    environment:
      - VPN_SERVICE_PROVIDER=windscribe
      - VPN_TYPE=wireguard
      - WIREGUARD_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU=
      - WIREGUARD_ADDRESSES=10.64.222.21/32
      - WIREGUARD_PRESHARED_KEY=
      - SERVER_REGIONS=Netherlands
```

## Required environment variables

- `VPN_SERVICE_PROVIDER=windscribe`
- For "Build a Plan" subscriptions, you need to set `SERVER_REGIONS` to the region(s) you have access to. For example, `SERVER_REGIONS=Sweden,Italy`.

### OpenVPN only

- `OPENVPN_USER`: Your username (get it from a generated config file from [fra.windscribe.com/getconfig/openvpn](https://fra.windscribe.com/getconfig/openvpn))
- `OPENVPN_PASSWORD`: Your password (get it from a generated config file from [fra.windscribe.com/getconfig/openvpn](https://fra.windscribe.com/getconfig/openvpn))

### Wireguard only

- `WIREGUARD_PRIVATE_KEY` is your 32 bytes key in base64 format. Note this is specific by user and the same for all servers.
- `WIREGUARD_ADDRESSES` is your IP network interface address in the format `xx.xx.xx.xx/xx`. Note this is specific by user and the same for all servers.
- `WIREGUARD_PRESHARED_KEY` is your optional preshared key

## Optional environment variables

- `SERVER_REGIONS`: Comma separated list of regions
- `SERVER_CITIES`: Comma separated list of cities
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames
- `VPN_ENDPOINT_PORT`: Custom OpenVPN server endpoint port to use, see [this list of ports](https://windscribe.com/getconfig/openvpn)
- `VPN_ENDPOINT_PORT`: Custom Wireguard server endpoint port to use, which can be one of: `53`, `80`, `123`, `443`, `1194`, `65142`

### VPN server port forwarding

1. Follow the [Windscribe instructions](https://windscribe.com/support/article/37/what-is-ephemeral-port-forwarding-and-how-to-use-it)
1. In your container configuration, set `FIREWALL_VPN_INPUT_PORTS` to the port you have been assigned, for example: `FIREWALL_VPN_INPUT_PORTS=8099`

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
