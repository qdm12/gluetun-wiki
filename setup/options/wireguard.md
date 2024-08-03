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
| `WIREGUARD_IMPLEMENTATION` | `auto` | `auto`, `kernelspace` or `userspace` | Wireguard implementation to use |
| `WIREGUARD_MTU` | `1400` | Any positive value up to `65535` | Wireguard MTU |
| `WIREGUARD_PERSISTENT_KEEPALIVE_INTERVAL` | | Any duration, for example `25s` | Wireguard persistent keepalive interval |
