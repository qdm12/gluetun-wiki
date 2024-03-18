# TUN device common errors

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.setup.tun)

There can be various issues regarding the *TUN device* depending on your host environment.

## `cannot Unix Open TUN device file: operation not supported`

This usually means you do not have the `tun` kernel module.

Usually loading the module on your host with `insmod /lib/modules/tun.ko` or `modprobe /lib/modules/tun.ko` should do the trick.

Otherwise you might have to re-compile your Kernel with the `tun` module.

## `cannot Unix Open TUN device file: no such device`

This is still unclear why this is caused, but probably running the container with `--device /dev/net/tun` solves it.

- [Issue opened](https://github.com/qdm12/gluetun/issues/700) by [@iceball09](https://github.com/iceball09)
- [Resolution comment](https://github.com/qdm12/gluetun/issues/700#issuecomment-1041221287) by [@YanisKyr](https://github.com/YanisKyr)

## `cannot create TUN device file node: operation not permitted`

This can happen when running LXC containers.

1. Find your LXC container number, let's call it `12345`
1. Edit `/etc/pve/lxc/12345.conf` and add:

    ```conf
    lxc.cgroup2.devices.allow: c 10:200 rwm
    lxc.mount.entry: /dev/net dev/net none bind,create=dir
    lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
    ```

1. In your run command or docker-compose.yml, use:

    ```sh
    --device /dev/net/tun:/dev/net/tun
    ```

    or

    ```yml
    devices:
      - /dev/net/tun:/dev/net/tun
    ```

Thanks to [@Vendetta1985](https://github.com/Vendetta1985), [source comment](https://github.com/qdm12/gluetun/issues/700#issuecomment-1039595490)

## `TUN device is not available: open /dev/net/tun: permission denied`

This can happen with `podman`.
The only way known is to run the container with `--privileged`.

Thanks to [@OkanEsen](https://github.com/OkanEsen), [source comment](https://github.com/qdm12/gluetun/issues/700#issuecomment-1046259375)

## `cannot Unix Open TUN device file: operation not permitted` and `cannot create TUN device file node: operation not permitted`

This happens on LXC containers.

1. Find your container number, let's call it `12345`
1. Edit `/etc/pve/lxc/12345.conf` and add:

    ```conf
    lxc.cgroup2.devices.allow: c 10:200 rwm
    lxc.mount.entry: /dev/net dev/net none bind,create=dir
    lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
    ```

1. In your run command or docker-compose.yml, use:

    ```sh
    --device /dev/net/tun:/dev/net/tun
    ```

    or

    ```yml
    devices:
      - /dev/net/tun:/dev/net/tun
    ```

🙏 thanks to [@user037951](https://github.com/user037951), [source discussion](https://github.com/qdm12/gluetun/discussions/637#discussioncomment-2120340).
🙏 thanks to [@Vendetta1985](https://github.com/Vendetta1985), [source comment](https://github.com/qdm12/gluetun/issues/700#issuecomment-1039595490)

## `creating TUN device file node: file exists`

Either:

- You need to run your Docker command as root by prefixing it with `sudo`. 🙏 thanks to [@jnelle](https://github.com/jnelle), [source comment](https://github.com/qdm12/gluetun/issues/884#issuecomment-1064918519)
- You have a mismatch between your Kernel and the installed tun module. This can happen when upgrading your system and not rebooting. A simple reboot might fix it. 🙏 thanks to [@aviolaris](https://github.com/aviolaris), [original issue](https://github.com/qdm12/gluetun/issues/1537)
- Validate if the module `tun` is loaded correctly in the current kernel, see the [original issue](https://github.com/qdm12/gluetun-wiki/issues/55)
