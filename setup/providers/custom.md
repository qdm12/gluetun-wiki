# Custom provider

## TLDR

### OpenVPN

💁 See the [Openvpn configuration file page](../openvpn-configuration-file.md) for information on how to set this up.

```sh
docker run -it --rm --cap-add=NET_ADMIN \
-e VPN_SERVICE_PROVIDER=custom -e VPN_TYPE=openvpn \
-v /yourpath/yourconfig.conf:/gluetun/custom.conf:ro \
-e OPENVPN_CUSTOM_CONFIG=/gluetun/custom.conf \
-e OPENVPN_USER=abc -e OPENVPN_PASSWORD=abc qmcgaw/gluetun
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
    volumes:
      - ./yourovpnconfig.conf:/gluetun/custom.conf:ro
    environment:
      - VPN_SERVICE_PROVIDER=custom
      - VPN_TYPE=openvpn
      - OPENVPN_CUSTOM_CONFIG=/gluetun/custom.conf
```

### Wireguard

```sh
docker run -it --rm --cap-add=NET_ADMIN \
-e VPN_SERVICE_PROVIDER=custom -e VPN_TYPE=wireguard \
-e WIREGUARD_ENDPOINT_IP=1.2.3.4 \
-e WIREGUARD_ENDPOINT_PORT=51820 \
-e WIREGUARD_PUBLIC_KEY=wAUaJMhAq3NFutLHIdF8AN0B5WG8RndfQKLPTEDHal0= \
-e WIREGUARD_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU= \
-e WIREGUARD_PRESHARED_KEY=xOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU= \
-e WIREGUARD_ADDRESSES="10.64.222.21/32" \
qmcgaw/gluetun
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
      - VPN_SERVICE_PROVIDER=custom
      - VPN_TYPE=wireguard
      - WIREGUARD_ENDPOINT_IP=1.2.3.4
      - WIREGUARD_ENDPOINT_PORT=51820
      - WIREGUARD_PUBLIC_KEY=wAUaJMhAq3NFutLHIdF8AN0B5WG8RndfQKLPTEDHal0=
      - WIREGUARD_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU=
      - WIREGUARD_PRESHARED_KEY=xOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU=
      - WIREGUARD_ADDRESSES=10.64.222.21/32
```

💁 You can also bind mount a wireguard configuration file (ini format) to `/gluetun/wireguard/wg0.conf`.

⚠️ Note you MUST for now use an IP address for `WIREGUARD_ENDPOINT_IP`, domain names are not supported.
Subscribe to [this issue](https://github.com/qdm12/gluetun/issues/2680) to be notified when this is supported.

### Amneziawg

```sh
docker run -it --rm --cap-add=NET_ADMIN \
-e VPN_SERVICE_PROVIDER=custom -e VPN_TYPE=amneziawg \
-e AMNEZIAWG_ENDPOINT_IP=1.2.3.4 \
-e AMNEZIAWG_ENDPOINT_PORT=51820 \
-e AMNEZIAWG_PUBLIC_KEY=wAUaJMhAq3NFutLHIdF8AN0B5WG8RndfQKLPTEDHal0= \
-e AMNEZIAWG_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU= \
-e AMNEZIAWG_PRESHARED_KEY=xOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU= \
-e AMNEZIAWG_ADDRESSES="10.64.222.21/32" \
-e AMNEZIAWG_JC=1 -e AMNEZIAWG_JMIN=10 -e AMNEZIAWG_JMAX=20 \
qmcgaw/gluetun
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
      - VPN_SERVICE_PROVIDER=custom
      - VPN_TYPE=amneziawg
      - AMNEZIAWG_ENDPOINT_IP=1.2.3.4
      - AMNEZIAWG_ENDPOINT_PORT=51820
      - AMNEZIAWG_PUBLIC_KEY=wAUaJMhAq3NFutLHIdF8AN0B5WG8RndfQKLPTEDHal0=
      - AMNEZIAWG_PRIVATE_KEY=wOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU=
      - AMNEZIAWG_PRESHARED_KEY=xOEI9rqqbDwnN8/Bpp22sVz48T71vJ4fYmFWujulwUU=
      - AMNEZIAWG_ADDRESSES=10.64.222.21/32
      - AMNEZIAWG_JC=1
      - AMNEZIAWG_JMIN=10
      - AMNEZIAWG_JMAX=20
```

💁 You can also bind mount a wireguard configuration file (ini format) to `/gluetun/amneziawg/awg0.conf`.

⚠️ Note you MUST for now use an IP address for `WIREGUARD_ENDPOINT_IP`, domain names are not supported.
Subscribe to [this issue](https://github.com/qdm12/gluetun/issues/2680) to be notified when this is supported.

## Required environment variables

- `VPN_SERVICE_PROVIDER=custom`

### OpenVPN only

- `OPENVPN_CUSTOM_CONFIG`: Path to your custom configuration file.

### Wireguard only

- `WIREGUARD_ENDPOINT_IP`: the server endpoint IP address
- `WIREGUARD_ENDPOINT_PORT`: the server endpoint port
- `WIREGUARD_PUBLIC_KEY` is the server 32 bytes public key in base64 format.
- `WIREGUARD_PRIVATE_KEY` is your 32 bytes private key in base64 format.
- `WIREGUARD_ADDRESSES` is your IP network interface address in the format `xx.xx.xx.xx/xx`.
- `WIREGUARD_PRESHARED_KEY` is your 32 bytes pre-shared key in base64 format. This is often optional and can be left unset.

### Amneziawg only

- `AMNEZIAWG_ENDPOINT_IP`: the server endpoint IP address
- `AMNEZIAWG_ENDPOINT_PORT`: the server endpoint port
- `AMNEZIAWG_PUBLIC_KEY` is the server 32 bytes public key in base64 format.
- `AMNEZIAWG_PRIVATE_KEY` is your 32 bytes private key in base64 format.
- `AMNEZIAWG_ADDRESSES` is your IP network interface address in the format `xx.xx.xx.xx/xx`.
- `AMNEZIAWG_PRESHARED_KEY` is your 32 bytes pre-shared key in base64 format. This is often optional and can be left unset.
