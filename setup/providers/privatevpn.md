# PrivateVPN

## TLDR

```sh
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=privatevpn \
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
    environment:
      - VPN_SERVICE_PROVIDER=privatevpn
      - OPENVPN_USER=abc
      - OPENVPN_PASSWORD=abc
      - SERVER_COUNTRIES=Netherlands
```

## Required environment variables

- `VPN_SERVICE_PROVIDER=privatevpn`
- `OPENVPN_USER`
- `OPENVPN_PASSWORD`

## Optional environment variables

- `SERVER_COUNTRIES`: Comma separated list of countries
- `SERVER_CITIES`: Comma separated list of cities
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames
- `VPN_ENDPOINT_PORT`: Custom OpenVPN server endpoint port to use

## VPN server port forwarding

PrivateVPN can assign you [a VPN server forwarded port](https://privatevpn.com/blog/guides/195/the-best-vpn-configuration-for-torrenting-fast-(and-safely)).
In that case, allow the port in the firewall following [setup/advanced/vpn-port-forwarding](../advanced/vpn-port-forwarding.md#allow-a-forwarded-port-through-the-firewall)

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
