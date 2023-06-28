# Synology prerequisites

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.setup.synology)

On some Synology devices, you must install the `tun` kernel module on your host at every boot. To do so, open a terminal and enter:

```sh
sudo insmod /lib/modules/tun.ko
```

This will also install the `tun` device after a reboot (see [#1296](https://github.com/qdm12/gluetun/issues/1296))
