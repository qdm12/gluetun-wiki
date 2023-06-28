# 32 bit OS prerequisites

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.setup.32bit)

On some 32 bit operating systems, you might encounter an OpenVPN error similar to:

```log
VERIFY ERROR: depth=0, error=format error in CRL's lastUpdate field: ...
OpenSSL: error:1416F086:SSL routines:tls_process_server_certificate:certificate verify failed
TLS_ERROR: BIO read tls_read_plaintext error
```

This is because since gluetun `v3.16.0`, the base Docker image system was upgraded from Alpine 3.12 to 3.13, which [has a different time representation](https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.13.0#time64_requirements).
It struggles because of `lastUpdate field` which is a time field.
The change only affects 32 bit systems running a kernel without this new time representation support.

## Raspberry Pis

For Raspberry Pis running 32 bit operating systems (such as Raspbian), you can either:

- (Untested) Upgrade containerd.io to version `1.4.3-2` or above:

    ```sh
    sudo apt-get update -y
    sudo apt-get install -y containerd.io
    sudo apt list containerd.io
    # should show 1.4.3-2 or above
    ```

- Upgrade `libseccomp2` to `2.4.2` or above and ensure your Docker version is `19.03.9` or above:

    ```sh
    sudo apt list libseccomp2
    # this should show a version below 2.4.2
    docker version --format {{.Server.Version}}
    # should show 19.03.9 or above, otherwise upgrade your Docker
    wget -qO /tmp/libseccomp2.deb https://ftp.debian.org/debian/pool/main/libs/libseccomp/libseccomp2_2.5.1-1_armhf.deb
    sudo dpkg -i /tmp/libseccomp2.deb
    rm /tmp/libseccomp2.deb
    sudo apt list libseccomp2
    # should show 2.5.1-1
    ```

You can now restart gluetun and it should be working.

## Debian x86

For x86 Debian operating systems, you can either:

- (Untested) Upgrade containerd.io to version `1.4.3-2` or above:

    ```sh
    sudo apt-get update -y
    sudo apt-get install -y containerd.io
    sudo apt list containerd.io
    # should show 1.4.3-2 or above
    ```

- Upgrade `libseccomp2` to `2.4.2` or above and ensure your Docker version is `19.03.9` or above:

    ```sh
    sudo apt list libseccomp2
    # this should show a version below 2.4.2
    docker version --format {{.Server.Version}}
    # should show 19.03.9 or above, otherwise upgrade your Docker
    ```

    Let's first try using the Debian package manager directly:

    ```sh
    sudo apt-get update -y
    sudo apt-get install libseccomp2
    sudo apt list libseccomp2
    # should show a version superior to 2.4.2
    ```

    If the last command shows a version inferior to `2.4.2`, then do the following:

    ```sh
    wget -qO /tmp/libseccomp2.deb https://ftp.debian.org/debian/pool/main/libs/libseccomp/libseccomp-dev_2.5.1-1_i386.deb
    sudo dpkg -i /tmp/libseccomp2.deb
    rm /tmp/libseccomp2.deb
    sudo apt list libseccomp2
    # should show 2.5.1-1
    ```

You can now restart gluetun and it should be working.

## Other 32 bit OSes

Try to follow the recommendations from the [Alpine page](https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.13.0#time64_requirements).

Feel free to open a Github issue with your positive/negative experience so I can later update this Wiki page.
