# Explanations

## What files does it download after tunneling

If `DOT=off`, Unbound won't run and therefore no file will be downloaded by the program at all.

If `DOT=on`, after tunneling, it downloads at start (and periodically if `DNS_UPDATE_PERIOD` is not `0`):

- [DNS named root](https://github.com/qdm12/files/blob/master/named.root.updated) and the [DNS root key](https://github.com/qdm12/files/blob/master/root.key.updated) for Unbound
- If `BLOCK_MALICIOUS=on`: [Malicious hostnames and IP addresses block lists](https://github.com/qdm12/files) for Unbound
- If `BLOCK_SURVEILLANCE=on`: [Surveillance hostnames and IP addresses block lists](https://github.com/qdm12/files) for Unbound
- If `BLOCK_ADS=on`: [Ads hostnames and IP addresses block lists](https://github.com/qdm12/files) for Unbound

## Server information

Gluetun uses IP addresses instead of hostnames to connect to VPN servers, to avoid doing a DNS resolution at start.

The main reason is Gluetun should not have connectivity before it establishes the VPN connection,
such that connected containers (or other machines) won't leak their data out for the few starting seconds.

The program comes with more than 10,000 IP addresses built in the program, split for each VPN provider supported.

These however can get outdated. In this case, you have multiple options:

- Pull the latest Docker image `docker pull qmcgaw/gluetun`. I update myself the server information *hardcoded* in the program from time to time, so you will get new ones by updating gluetun.
- [Update the VPN servers list yourself](../setup/servers.md#update-the-vpn-servers-list).

## What is all this Go code

The Go code was essentially a big rewrite of the previous shell entrypoint.
It now acts a supervisor program, and has a built-in HTTP control server.

It allows for:

- better testing
- better maintainability
- ease of implementing new features
- faster start time
- asynchronous/parallel operations
- Restarting openvpn/unbound when needed without quitting the container

It is mostly made of the [internal directory](https://github.com/qdm12/gluetun/tree/master/internal) and the entry Go file [cmd/main.go](https://github.com/qdm12/gluetun/blob/master/cmd/gluetun/main.go).
