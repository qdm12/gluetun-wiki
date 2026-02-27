# PureVPN

## TLDR

```sh
docker run -it --rm --cap-add=NET_ADMIN --device /dev/net/tun \
-e VPN_SERVICE_PROVIDER=purevpn \
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
    devices:
      - /dev/net/tun:/dev/net/tun
    environment:
      - VPN_SERVICE_PROVIDER=purevpn
      - OPENVPN_USER=abc
      - OPENVPN_PASSWORD=abc
      - SERVER_COUNTRIES=Netherlands
```

💁 To use with Wireguard, see [the custom provider Wireguard section](custom.md#wireguard).

## Required environment variables

- `VPN_SERVICE_PROVIDER=purevpn`
- `OPENVPN_USER`
- `OPENVPN_PASSWORD`

## Optional environment variables

- `SERVER_COUNTRIES`: Comma separated list of countries
- `SERVER_CITIES`: Comma separated list of cities
- `SERVER_TYPES`: Comma separated list of PureVPN type filters. Servers must match all values set.
  - Allowed values:
    - `regular`: non-`portforwarding`, non-`quantumresistant`, non-`obfuscation`, non-`p2p`
    - `portforwarding`
    - `quantumresistant`
    - `obfuscation`
    - `p2p`
  - Accepted aliases:
    - `portforward`, `pf` -> `portforwarding`
    - `quantum`, `qr` -> `quantumresistant`
    - `obfuscated`, `obf` -> `obfuscation`
- `SERVER_CATEGORIES`: Comma separated list of server categories from the PureVPN inventory feed. Servers must match all values set.
  - In current PureVPN data, the category in use is `p2p`.
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames. Beware this is the narrowest filter, so if you set this to a single hostname and this hostname disappears from the Gluetun servers data due to an update, your container will no longer work until this filter is changed. I would suggest avoiding it unless you know this reliability risk.

## Filtering examples

### By type

```sh
# Any obfuscated server
SERVER_TYPES=obfuscation

# Must be both p2p and quantum resistant
SERVER_TYPES=p2p,quantumresistant

# Alias example, equivalent to SERVER_TYPES=portforwarding,obfuscation
SERVER_TYPES=pf,obf
```

### By category

```sh
# Current PureVPN category usage
SERVER_CATEGORIES=p2p
```

### Combined with location

```sh
# In US/Canada, city match, and must be p2p + quantum resistant
SERVER_COUNTRIES=United States,Canada
SERVER_CITIES=New York,Toronto
SERVER_TYPES=p2p,quantumresistant
```

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
