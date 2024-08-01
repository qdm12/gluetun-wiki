# Wireguard

## Kernelspace

If you don't have Wireguard in your kernel (👀 Synology users), you can install them following [@macdis' comment](https://github.com/qdm12/gluetun/issues/134#issuecomment-1500962965) which might bring significant [bandwidth gains](../../faq/bandwidth.md).

## Load Wireguard Kernel module

Some systems do not load automatically the Wireguard module at start.

The more appropriate way is to configure your system to run `modprobe wireguard` at boot before launching Docker.

Alternatively, `modprobe` is natively implemented in Gluetun. This one is used to try loading the Wireguard kernel module if it is not found.
To do so however, you need to:

- add the `SYS_MODULE` container capability
- bind mount (read only) the volume `/lib/modules:/lib/modules:ro`

For example in a docker-compose.yml file:

```yml
cap_add:
  - SYS_MODULE
volumes:
  - /lib/modules:/lib/modules:ro
```
