# Wireguard options

## Files

You can bind mount an ini Wireguard configuration file to `/gluetun/wireguard/wg0.conf`.
Any field present will be extracted from it and used.
Note any field value set in this file takes precedence over the environment variables.

## Environment variables

If using the Wireguard protocol, depending on the provider, the following might be compulsory:

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `WIREGUARD_PRIVATE_KEY` | | Valid base 58 Wireguard key | Wireguard client private key to use. This is usually always needed. |
| `WIREGUARD_ADDRESSES` | | Valid IP network interface address in the format `xx.xx.xx.xx/xx` | This is usually needed. |
| `WIREGUARD_PUBLIC_KEY` | | Valid base 58 Wireguard key | Wireguard server public key to use. This may or may not be needed. |
| `WIREGUARD_ENDPOINT_IP` |  | Valid IP address | Specify a generally optional target VPN server IP address to use |
| `WIREGUARD_ENDPOINT_PORT` | | Valid port number | Specify a generally optional target VPN server port number to use |

💁 The following environment variables are all optional:

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `WIREGUARD_PRESHARED_KEY` | | Base64 pre-shared key | Wireguard pre-shared key |
| `WIREGUARD_ALLOWED_IPS` | `0.0.0.0/0,::/0` | CSV of IP address ranges | Wireguard peer allowed ips |
| `WIREGUARD_IMPLEMENTATION` | `auto` | `auto`, `kernelspace`, `userspace` or `amneziawg` | Wireguard implementation to use |
| `WIREGUARD_MTU` | `1400` | Any positive value up to `65535` | Wireguard MTU |
| `WIREGUARD_PERSISTENT_KEEPALIVE_INTERVAL` | | Any duration, for example `25s` | Wireguard persistent keepalive interval |

## Amnezia WG

Additionaly you can setup AmneziaWG parameters (works only when `WIREGUARD_IMPLEMENTATION` is set to `amneziawg` and `VPN_SERVICE_PROVIDER` is set to `custom`):

| Variable         | Default | Choices                                                   | Description                               |
| --------------   | ------- | --------------------------------------------------------- | ----------------------------------------- |
| `WIREGUARD_JC`   |         | Recommended range is 4-12                                 | The amount of junk packets                |
| `WIREGUARD_JMIN` |         | Jmin: int <= Jmax: int                                    | Junk packet min size                      |
| `WIREGUARD_JMAX` |         | Should be less than MTU                                   | Junk packet max size                      |
| `WIREGUARD_S1`   |         | int                                                       | Padding of handshake initial message      |
| `WIREGUARD_S2`   |         | int                                                       | Padding of handshake response message     |
| `WIREGUARD_S3`   |         | int                                                       | Padding of handshake cookie message       |
| `WIREGUARD_S4`   |         | int                                                       | Padding of transport message              |
| `WIREGUARD_H1`   |         | range: x-y, x <= y; e.g. `123-456` or single value `1234` | Header range of handshake initial message |
| `WIREGUARD_H2`   |         | range: x-y, x <= y; e.g. `123-456` or single value `1234` | Header range of handshake initial message |
| `WIREGUARD_H3`   |         | range: x-y, x <= y; e.g. `123-456` or single value `1234` | Header range of handshake cookie message  |
| `WIREGUARD_H4`   |         | range: x-y, x <= y; e.g. `123-456` or single value `1234` | Header range of transport message         |
| `WIREGUARD_I2`   |         | Can be read in AmneziaWG docs                             | Custom signature packet 2                 |
| `WIREGUARD_I3`   |         | Can be read in AmneziaWG docs                             | Custom signature packet 3                 |
| `WIREGUARD_I1`   |         | Can be read in AmneziaWG docs                             | Custom signature packet 1                 |
| `WIREGUARD_I4`   |         | Can be read in AmneziaWG docs                             | Custom signature packet 4                 |
| `WIREGUARD_I5`   |         | Can be read in AmneziaWG docs                             | Custom signature packet 5                 |
