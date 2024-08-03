# VyprVPN

## TLDR

```sh
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=vyprvpn \
-e OPENVPN_USER=abc -e OPENVPN_PASSWORD=abc \
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
      - VPN_SERVICE_PROVIDER=vyprvpn
      - OPENVPN_USER=abc
      - OPENVPN_PASSWORD=abc
      - SERVER_REGIONS=Netherlands
```

💁 To use with Wireguard, see [the custom provider Wireguard section](custom.md#wireguard).

## Required environment variables

- `VPN_SERVICE_PROVIDER=vyprvpn`
- `OPENVPN_USER`
- `OPENVPN_PASSWORD`

## Optional environment variables

- `SERVER_REGIONS`: Comma separated list of regions
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames

## VPN server port forwarding

By default, VyprVPN does not forward any port.

You need to disable the NAT firewall in the Manage services section of your account at [account.vyprvpn.com](https://account.vyprvpn.com/) ([source](https://support.vyprvpn.com/hc/en-us/articles/360039668472-Does-VyprVPN-support-Port-Forwarding-)).

All the ports will then be forwarded to you, so it's like you are running alone on the VPN server.

Therefore, you only need to allow these ports through the gluetun firewall by setting the ports you need in `FIREWALL_VPN_INPUT_PORTS`.
For example `FIREWALL_VPN_INPUT_PORTS=8000,9000`.

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
