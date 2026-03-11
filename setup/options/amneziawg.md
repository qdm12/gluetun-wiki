# Amneziawg options

## Files

You can bind mount an ini Amneziawg configuration file to `/gluetun/amneziawg/awg0.conf`.
Any field present will be extracted from it and used.
Note any field value set in this file takes precedence over the environment variables.

## Environment variables

The following environment variables all need to be specified:

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `AMNEZIAWG_PRIVATE_KEY` | | Valid base 58 Amneziawg key | Amneziawg client private key to use. This is usually always needed. |
| `AMNEZIAWG_ADDRESSES` | | Valid IP network interface address in the format `xx.xx.xx.xx/xx` | This is usually needed. |
| `AMNEZIAWG_PUBLIC_KEY` | | Valid base 58 Amneziawg key | Amneziawg server public key to use. This may or may not be needed. |
| `AMNEZIAWG_ENDPOINT_IP` | | Valid IP address | Specify a generally optional target VPN server IP address to use |
| `AMNEZIAWG_ENDPOINT_PORT` | | Valid port number | Specify a generally optional target VPN server port number to use |

💁 The following environment variables are all optional:

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `AMNEZIAWG_PRESHARED_KEY` | | Base64 pre-shared key | Amneziawg pre-shared key |
| `AMNEZIAWG_ALLOWED_IPS` | `0.0.0.0/0,::/0` | CSV of IP address ranges | Amneziawg peer allowed ips |
| `AMNEZIAWG_MTU` | | Any positive value generally up to `1440`, probably lower with Amneziawg | Amneziawg MTU |
| `AMNEZIAWG_PERSISTENT_KEEPALIVE_INTERVAL` | | Any duration, for example `25s` | Amneziawg persistent keepalive interval |
| `AMNEZIAWG_JC` | `0` | Any positive integer | Number of junk packets following I1-I5 and sent before the actual handshake initiation |
| `AMNEZIAWG_JMIN` | `0` | Any positive integer and must be less than or equal to `AMNEZIAWG_JMAX` | Minimum size in bytes of the random junk data prefixed to the handshake packet |
| `AMNEZIAWG_JMAX` | `0` | Any positive integer and must be greater than or equal to `AMNEZIAWG_JMIN` | Maximum size in bytes of the random junk data prefixed to the handshake packet |
| `AMNEZIAWG_S1` | `0` | Any positive integer | Random bytes to pad the handshake initiation packets |
| `AMNEZIAWG_S2` | `0` | Any positive integer | Random bytes to pad the handshake response packets |
| `AMNEZIAWG_S3` | `0` | Any positive integer | Random bytes to pad the handshake cookie reply packets |
| `AMNEZIAWG_S4` | `0` | Any positive integer | Random bytes to pad the encrypted transport data packets |
| `AMNEZIAWG_H1` | `0` | `n` or range `n-m`, with values from `0` to `4294967295` | header range of the handshake initiation message |
| `AMNEZIAWG_H2` | `0` | `n` or range `n-m`, with values from `0` to `4294967295` | header range of the handshake response message |
| `AMNEZIAWG_H3` | `0` | `n` or range `n-m`, with values from `0` to `4294967295` | header range of the handshake cookie reply message |
| `AMNEZIAWG_H4` | `0` | `n` or range `n-m`, with values from `0` to `4294967295` | header range of the transport data message |
| `AMNEZIAWG_I1` | | | See [custom signature packets](https://github.com/amnezia-vpn/amneziawg-go?tab=readme-ov-file#custom-signature-packets) |
| `AMNEZIAWG_I2` | | | See [custom signature packets](https://github.com/amnezia-vpn/amneziawg-go?tab=readme-ov-file#custom-signature-packets) |
| `AMNEZIAWG_I3` | | | See [custom signature packets](https://github.com/amnezia-vpn/amneziawg-go?tab=readme-ov-file#custom-signature-packets) |
| `AMNEZIAWG_I4` | | | See [custom signature packets](https://github.com/amnezia-vpn/amneziawg-go?tab=readme-ov-file#custom-signature-packets) |
| `AMNEZIAWG_I5` | | | See [custom signature packets](https://github.com/amnezia-vpn/amneziawg-go?tab=readme-ov-file#custom-signature-packets) |

Additional notes:

- Be careful with "high numbers" for these parameters, this can cause out of memory crashes, or fragment packets because they would be too large to fit within the VPN link MTU, which would make them more identifiable and less performant.
- `AMNEZIAWG_JC`, `AMNEZIAWG_JMIN`, `AMNEZIAWG_JMAX` and custom signature packets (`AMNEZIAWG_I1` etc.) can be applied independently of how the AmneziaWG server is configured, unlike other AmneziaWG parameters.

([Source](https://docs.amnezia.org/documentation/amnezia-wg/#configuration-parameters))
