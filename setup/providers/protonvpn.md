# ProtonVPN

## TLDR

```sh
# OpenVPN
docker run -it --rm --cap-add=NET_ADMIN --device /dev/net/run \
-e VPN_SERVICE_PROVIDER=protonvpn \
-e OPENVPN_USER=abc -e OPENVPN_PASSWORD=abc \
-e SERVER_COUNTRIES=Netherlands qmcgaw/gluetun
```

```sh
# Wireguard
docker run -it --rm --cap-add=NET_ADMIN --device /dev/net/run \
-e VPN_SERVICE_PROVIDER=protonvpn \
-e VPN_TYPE=wireguard \
-e WIREGUARD_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU= \
-e SERVER_COUNTRIES=Netherlands qmcgaw/gluetun
```

```yml
version: "3"
services:
  gluetun:
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun:/dev/net/tun
    environment:
      - VPN_SERVICE_PROVIDER=protonvpn
      - VPN_TYPE=wireguard
      - WIREGUARD_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU=
      - SERVER_COUNTRIES=Netherlands
```

## Required environment variables

- `VPN_SERVICE_PROVIDER=protonvpn`

### OpenVPN only

- `OPENVPN_USER` is your **OPENVPN specific** username. Find it at [account.proton.me/u/0/vpn/OpenVpnIKEv2](https://account.proton.me/u/0/vpn/OpenVpnIKEv2).
- `OPENVPN_PASSWORD`

### WireGuard only

- `VPN_TYPE=wireguard`
- `WIREGUARD_PRIVATE_KEY` is your 32 byte key in base64 format.

💁 To obtain the `WIREGUARD_PRIVATE_KEY` value, provision a configuration file from [account.proton.me/u/0/vpn/WireGuard](https://account.proton.me/u/0/vpn/WireGuard). The content of the WireGuard configuration file that ProtonVPN generates contains the `PrivateKey` value in the `[Interface]` section. Note that the private key value is the same for all ProtonVPN servers. All other values in the ProtonVPN WireGuard Configuration file should be ignored and not set in Gluetun environment variables. [ProtonVPN documentation on how to generate a WireGuard configuration file](https://protonvpn.com/support/wireguard-configurations/)

## Optional environment variables

- `SERVER_COUNTRIES`: Comma separated list of countries
- `SERVER_REGIONS`: Comma separated list of regions
- `SERVER_CITIES`: Comma separated list of cities
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames
- `FREE_ONLY`: Filter only free tier servers by setting it to `on`. It defaults to `off`.
- `STREAM_ONLY`: Filter only free tier servers by setting it to `on`. It defaults to `off`.
- `SECURE_CORE_ONLY`: Filter only secure core servers by setting it to `on`. It defaults to `off`.
- `TOR_ONLY`: Filter only TOR servers by setting it to `on`. It defaults to `off`.
- `PORT_FORWARD_ONLY`: Filter only port-forwarding enabled (aka *p2p*) servers by setting it to `on`. It defaults to `off`.
- `OPENVPN_ENDPOINT_PORT`: Custom OpenVPN server endpoint port to use
  - For TCP: `443`, `5995` or `8443`
  - For UDP: `80`, `443`, `1194`, `4569`, `5060`
  - Defaults are `1194` for UDP and `443` for TCP
- `VPN_PORT_FORWARDING`: defaults to `off` and can be set to `on`to enable port forwarding on the VPN server.

## VPN server port forwarding

Requirements:

- `VPN_PORT_FORWARDING=on`
- `PORT_FORWARD_ONLY=on` to tell Gluetun to only connect to servers that support port forwarding
- For OpenVPN
  - Append `+pmp` to your OpenVPN username. For example, if your ProtonVPN username was `johndoe`, set `OPENVPN_USER` to `johndoe+pmp` (thanks to [@mortimr](https://github.com/qdm12/gluetun/issues/1760#issuecomment-1669518288)). ProtonVPN documentation on [port forwarding with OpenVPN](https://protonvpn.com/support/port-forwarding-manual-setup#openvpn)
- For WireGuard
  - Set `VPN_PORT_FORWARDING_PROVIDER=protonvpn`

## Multi hop regions

Simply set the `SERVER_HOSTNAMES` environment variable to a hostname corresponding to a multi hop region (see [Servers](#servers)).

For example setting `SERVER_HOSTNAMES=ch-us-01a.protonvpn.com` would set a multi hop with entry in Switzerland and exit in the US.

## Moderate NAT/NAT Type 2

Paid ProtonVPN subscribers can optionally use [Moderate NAT](https://protonvpn.com/support/moderate-nat/) on their connections.

To do so with OpenVPN, append `+nr` to the ProtonVPN username. For example, if your ProtonVPN username was `johndoe`, set `OPENVPN_USER` to `johndoe+nr`.

To do so with WireGuard, when provisioning a configuration file from [account.proton.me/u/0/vpn/WireGuard](https://account.proton.me/u/0/vpn/WireGuard), under `Select VPN options`, enable `Moderate NAT` before creating your configuration file containing your private key.

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
