# IPv6

💁 [@Vexz00](https://github.com/Vexz00) confirmed [nothing is leaking using IPv6](https://github.com/qdm12/gluetun-wiki/issues/70) 🎉

If you find something suspect related to IPv6, please create an issue on this repository 😉

## Setup

1. First make sure your VPN provider supports dual stack IPv4+IPv6. Notably Mullvad and AirVPN support it, but other providers may not.
   Related note is that the VPN server IP address you connect can be either IPv4 or IPv6, it does not matter to support dual stack.
1. Ensure your Kernel has IPv6

    ```sh
    lsmod | grep ipv6
    ```

    Should show something.
1. On your Docker host, edit and create if needed `/etc/docker/daemon.json` with the following JSON key-value pairs:

    ```json
    {
      "ipv6": true,
      "fixed-cidr-v6": "2001:db8:1::/64",
      "experimental": true,
      "ip6tables": true
    }
    ```

    ⚠️ Ensure to change the [documented address `2001:db8:1::/64`](https://en.wikipedia.org/wiki/Reserved_IP_addresses#IPv6) with a valid IPv6 network. The default IPv4 pools are from the private address range, the IPv6 equivalent would be ULA networks.

    [Reference: Docker documentation on IPv6](https://docs.docker.com/config/daemon/ipv6/#use-ipv6-for-the-default-bridge-network)
1. Restart the Docker daemon to reload its JSON configuration. Most Linux distributions use `sudo systemctl restart docker` to do this.
1. Edit your Gluetun `docker-compose.yml` and add the `sysctls` section:

    ```yaml
    services:
      gluetun:
        # ...
        sysctls:
          - net.ipv6.conf.all.disable_ipv6=0
    ```

1. You also need the bridge network in which Gluetun is running to support IPv6. For example

    ```yml
    networks:
      internet:
        enable_ipv6: true
        ipam:
          config:
            - subnet: 172.26.0.0/16
            - subnet: 2001:db8:1::/64 # Match the one in the Docker daemon configuration
    ```

1. Depending on the VPN protocol used:
    - OpenVPN: the IPv6 server address and configuration will automatically be picked up if IPv6 support is detected
    - Wireguard: modify the `WIREGUARD_ADDRESSES` value to have both an IPv4 and IPv6 address. Note if you only set an IPv6 Wireguard address, all IPv4 traffic won't go through which is undesirable.
1. Test your setup:
    1. Launch your docker-compose stack
    1. Run:

        ```sh
        sudo docker run --rm --network=container:gluetun alpine:3.22 sh -c "apk add curl && curl -6 --silent https://ipv6.ipleak.net/json/"
        ```

        And this should show the IPv6 address of the VPN server.
