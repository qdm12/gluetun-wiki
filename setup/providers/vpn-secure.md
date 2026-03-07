# VPN Secure

## TLDR

1. [Setup your client encrypted key](../advanced/openvpn-client-encrypted-key.md)
1. [Setup your client certificate](../advanced/openvpn-client-certificate.md)

```sh
docker run -it --rm --cap-add=NET_ADMIN --device /dev/net/tun \
-e VPN_SERVICE_PROVIDER=vpnsecure \
-v /yourpath/gluetun:/gluetun \
-e OPENVPN_KEY_PASSPHRASE=abc \
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
      - VPN_SERVICE_PROVIDER=vpnsecure
      - OPENVPN_KEY_PASSPHRASE=abc
      - SERVER_COUNTRIES=Netherlands
    volumes:
      # gluetun directory must contain the certificate
      # as client.crt and the encrypted key as openvpn_encrypted_key
      - ./gluetun:/gluetun
```

## Required environment variables

- `VPN_SERVICE_PROVIDER=vpnsecure`
- `OPENVPN_KEY_PASSPHRASE` is your account password

## Optional environment variables

- `SERVER_REGIONS`: Comma separated list of regions
- `SERVER_CITIES`: Comma separated list of cities
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames. Beware this is the narrowest filter, so if you set this to a single hostname and this hostname disappears from the Gluetun servers data due to an update, your container will no longer work until this filter is changed. I would suggest avoiding it unless you know this reliability risk.
- `PREMIUM_ONLY`: `yes` or `no`
- `OPENVPN_PROTOCOL`: `udp` or `tcp`, defaults to `udp`

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
