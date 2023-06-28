# Ivpn

## TLDR

```sh
# OpenVPN
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=ivpn \
-e VPN_TYPE=openvpn -e OPENVPN_USER=abc -e OPENVPN_PASSWORD=abc \
-e SERVER_CITIES=amsterdam qmcgaw/gluetun
```

```sh
# Wireguard
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=ivpn \
-e VPN_TYPE=wireguard \
-e WIREGUARD_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU= \
-e WIREGUARD_ADDRESSES="10.64.222.21/32" \
-e SERVER_CITIES=amsterdam qmcgaw/gluetun
```

```yml
version: "3"
services:
  gluetun:
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    environment:
      - VPN_SERVICE_PROVIDER=ivpn
      - VPN_TYPE=wireguard
      - WIREGUARD_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU=
      - WIREGUARD_ADDRESSES=10.64.222.21/32
      - SERVER_CITIES=Amsterdam
```

## Required environment variables

- `VPN_SERVICE_PROVIDER=ivpn`

### OpenVPN only

- `OPENVPN_USER` can be your email address or your account ID (`i-xxxx-xxxx-xxxx` or `ivpn-xxxx-xxxx-xxxx`)
- `OPENVPN_PASSWORD` is needed if `OPENVPN_USER` is **not** your account ID.

### Wireguard only

- `WIREGUARD_PRIVATE_KEY` is your 32 bytes key in base64 format. Note this is specific by user and the same for all servers.
- `WIREGUARD_ADDRESSES` is your IP network interface address in the format `xx.xx.xx.xx/xx`. Note this is specific by user and the same for all servers.

## Optional environment variables

- `SERVER_COUNTRIES`: Comma separated list of countries
- `SERVER_CITIES`: Comma separated list of cities
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames
- `ISP`: Comma separated list of ISPs
- `VPN_ENDPOINT_PORT`: Custom Wireguard server endpoint port to use, which can be one of: `2049`, `2050`, `53`, `30587`, `41893`, `48574`, `58237`

## VPN Port forwarding

1. Log in your IVPN account at [https://www.ivpn.net/account/](https://www.ivpn.net/account/)
1. Obtain a port from [https://www.ivpn.net/account/#/ports](https://www.ivpn.net/account/#/ports)
1. Add the port to the environment variable `FIREWALL_VPN_INPUT_PORTS`

## IPv6 tunneling with OpenVPN

IPv6 is automatically enabled in the routing, firewall, wireguard and openvpn setup if it's supported.

If you want to tunnel IPv6:

1. Ensure your Kernel has IPv6

    ```sh
    lsmod | grep ipv6
    ```

    Should show something.
1. Enable IPv6 in Docker for this container:
    - For a Docker run command, add the flag `--sysctl net.ipv6.conf.all.disable_ipv6=0` (or `--sysctl net.ipv6.conf.all.disable=0` on some systems)
    - For docker-compose.yml files, add this to your `gluetun` config block:

        ```yml
            sysctls:
              - net.ipv6.conf.all.disable_ipv6=0
        ```

1. Start the container

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
