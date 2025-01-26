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
1. ~~Edit `/etc/pve/lxc/12345.conf` and add:~~ -> **OUTDATED!**

    ```conf
    lxc.cgroup2.devices.allow: c 10:200 rwm
    lxc.mount.entry: /dev/net dev/net none bind,create=dir
    lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
    ```

1. Since Proxmox 8.1 you can add devices to your lxc container and no longer have to rewrite the permissions to your tun device which is a security risk
    1. run this commands at your pve host system to **SET** device

      ```sh
      pct set 123245 -dev0 /dev/net/tun
      pct reboot 12345
      ```

    1. run this commands at your pve host system to **UNSET** device

      ```sh
      pct set 12345 -delete dev0
      pct reboot 12345
      ````

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

This can happen with `podman`, usually due to SELinux. Create a SELinux policy to allow the rootless container to use the `/dev/net/tun` device.

1. Copy the content below to a new file `gluetun_policy.te`

    ```bash
    module gluetun_policy 1.0;

    require {
            type tun_tap_device_t;
            type container_file_t;
            type container_t;
            class chr_file { getattr ioctl open read write };
            class sock_file watch;
    }
    ```

1. Convert it to a policy module: `checkmodule -M -m -o gluetun_policy.mod gluetun_policy.te`
1. Compile the policy: `semodule_package -o gluetun_policy.pp -m gluetun_policy.mod`
1. Install the policy: `semodule -i gluetun_policy.pp`

Alternatively generate the policy yourself:

1. Start the container and extract the SELinux policy

    ```sh
    sudo grep gluetun /var/log/audit/audit.log | audit2allow -a -M gluetun_policy
    ```

1. Inspect the policy `cat gluetun_policy.te`
1. Install it with `semodule -i gluetun_policy.pp`
Another solution is to run the container with `--privileged`.

Thanks to [@OkanEsen](https://github.com/OkanEsen), [source comment](https://github.com/qdm12/gluetun/issues/700#issuecomment-1046259375)

## `cannot Unix Open TUN device file: operation not permitted` and `cannot create TUN device file node: operation not permitted`

This happens on LXC containers.

1. Find your container number, let's call it `12345`
1. ~~Edit `/etc/pve/lxc/12345.conf` and add:~~ -> **OUTDATED!**

    ```conf
    lxc.cgroup2.devices.allow: c 10:200 rwm
    lxc.mount.entry: /dev/net dev/net none bind,create=dir
    lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
    ```

1. Since Proxmox 8.1 you can add devices to your lxc container and no longer have to rewrite the permissions to your tun device which is a security risk
    1. run this commands at your pve host system tu **SET** device

      ```sh
      pct set 123245 -dev0 /dev/net/tun
      pct reboot 12345
      ```

    1. run this commands at your pve host system to **UNSET** device

      ```sh
      pct set 12345 -delete dev0
      pct reboot 12345
      ````

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

## `cannot Unix Open TUN device file: operation not permitted`

### Kubernetes

This can occur due to [a change in containerd](https://github.com/opencontainers/runc/pull/3468) that restricts access to the tun device from un-priviledged containers.

To resolve, ensure the container is marked as privileged:

  ```yaml
  containers:
    - image: ghcr.io/qdm12/gluetun:<version>
      securityContext:
        privileged: true
  ```

There is some additional context and discussion on [this issue](https://github.com/tailscale/tailscale/issues/10814) on the tailscale project.

## `creating TUN device file node: file exists`

Either:

- You need to run your Docker command as root by prefixing it with `sudo`. 🙏 thanks to [@jnelle](https://github.com/jnelle), [source comment](https://github.com/qdm12/gluetun/issues/884#issuecomment-1064918519)
- You have a mismatch between your Kernel and the installed tun module. This can happen when upgrading your system and not rebooting. A simple reboot might fix it. 🙏 thanks to [@aviolaris](https://github.com/aviolaris), [original issue](https://github.com/qdm12/gluetun/issues/1537)
- Validate if the module `tun` is loaded correctly in the current kernel, see the [original issue](https://github.com/qdm12/gluetun-wiki/issues/55)
