# Mullvad

## TLDR

```sh
# OpenVPN
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=mullvad \
-e VPN_TYPE=openvpn -e OPENVPN_USER=1355131650462193 \
-e SERVER_CITIES=amsterdam qmcgaw/gluetun
```

```sh
# Wireguard
docker run -it --rm --cap-add=NET_ADMIN -e VPN_SERVICE_PROVIDER=mullvad \
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
      - VPN_SERVICE_PROVIDER=mullvad
      - VPN_TYPE=wireguard
      - WIREGUARD_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU=
      - WIREGUARD_ADDRESSES=10.64.222.21/32
      - SERVER_CITIES=Amsterdam
```

## Required environment variables

- `VPN_SERVICE_PROVIDER=mullvad`

### OpenVPN only

- `OPENVPN_USER` which is your Mullvad user ID.

### Wireguard only

- `WIREGUARD_PRIVATE_KEY` is your 32 bytes key in base64 format. The private key can only be obtained by [generating a Wireguard configuration file](https://mullvad.net/en/account/#/wireguard-config). The `Wireguard Key` displayed on the [Manage devices and ports](https://mullvad.net/en/account/#/ports) page on Mullvad is *not* the private key that is required. Generate a Wireguard configuration file, download the zip file, extract any of the `.json` files within and use the `PrivateKey` value. Note this value is the same for all Mullvad servers. 💁 [Screenshots on how to obtain it](https://github.com/qdm12/gluetun/discussions/805#discussioncomment-2026642).
- `WIREGUARD_ADDRESSES` is the Wireguard IP network interface address in CIDR format `xx.xx.xx.xx/xx`. To obtain it, first download a Wireguard configuration file using same steps as for `WIREGUARD_PRIVATE_KEY` above. In the configuration file, locate the `Address` value. This one should contain a comma delimited list of an IPv4 and IPv6 address, so use the IPv4 address (usually the first one) as the value for the `WIREGUARD_ADDRESSES` environment variable. Note this is same value for all Mullvad servers and for your private key. 💁 [Screenshots on how to obtain it](https://github.com/qdm12/gluetun/discussions/805#discussioncomment-2026642).

## Optional environment variables

- `SERVER_COUNTRIES`: Comma separated list of countries
- `SERVER_CITIES`: Comma separated list of cities
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames
- `ISP`: Comma separated list of ISPs
- `OWNED_ONLY`: If the VPN server is owned by Mullvad. It defaults to `no`, meaning it includes all servers. It can be set to `yes`.
- `VPN_ENDPOINT_PORT`: custom server endpoint port to use
  - For OpenVPN:
    - TCP: it can only be `80`, `443` or `1401`
    - UDP: it can only be `53`, `1194`, `1195`, `1196`, `1197`, `1300`, `1301`,   `1302`, `1303` or `1400`
    - It defaults to `443` for TCP and `1194` for UDP
  - For Wireguard: it can be any value and defaults to `51820`

## IPv6 tunneling with OpenVPN

By default, IPv6 is just blocked by the firewall in gluetun.

If you want to tunnel IPv6 with Mullvad using OpenVPN:

1. Ensure your Kernel has IPv6

    ```sh
    lsmod | grep ipv6
    ```

    Should show something.
1. Set the environment variable `OPENVPN_IPV6` to `on`
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
