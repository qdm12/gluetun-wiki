# Cyberghost

## TLDR

1. [Setup your client key](../advanced/openvpn-client-key.md)
1. [Setup your client certificate](../advanced/openvpn-client-certificate.md)

```sh
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=cyberghost \
-e OPENVPN_USER=abc -e OPENVPN_PASSWORD=abc \
-v /yourpath:/gluetun \
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
      - VPN_SERVICE_PROVIDER=cyberghost
      - OPENVPN_USER=abc
      - OPENVPN_PASSWORD=abc
      - SERVER_COUNTRIES=Netherlands
    volumes:
      - ./gluetun:/gluetun
```

## Required environment variables

- `VPN_SERVICE_PROVIDER=cyberghost`
- `OPENVPN_USER`
- `OPENVPN_PASSWORD`

## Optional environment variables

- `SERVER_COUNTRIES`: Comma separated list of countries
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
