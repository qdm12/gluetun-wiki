# Popular apps

This document contains some tips on popular applications used with Gluetun.

## Qbittorrent

### Magnets links are stuck

In the Qbittorrent settings:

- set the "network interface" to `tun0`
- set the "optional IP address to bind to" to `all ipv4`

Thanks to @cryo-dog ([issue](https://github.com/qdm12/gluetun/issues/2735)).
