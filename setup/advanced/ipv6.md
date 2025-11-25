# IPv6

💁 [@Vexz00](https://github.com/Vexz00) confirmed [nothing is leaking using IPv6](https://github.com/qdm12/gluetun-wiki/issues/70) 🎉

If you find something suspect related to IPv6, please create an issue on this repository 😉

## Setup

1. Ensure your Kernel has IPv6

    ```sh
    lsmod | grep ipv6
    ```

    Should show something.
2. Modify your default network and add the `sysctls` section in your `docker-compose.yml` file as shown below, or alternatively create a new network that you add gluetun to:
```yaml
services:
  gluetun:
    # ...
    sysctls:
      - net.ipv6.conf.all.disable_ipv6=0

networks:
  default:
    enable_ipv6: true
    driver: bridge
```
3. Depending on the VPN protocol used:
- OpenVPN: the IPv6 server address and configuration will automatically be picked up if IPv6 support is detected
- Wireguard: modify the `WIREGUARD_ADDRESSES` value to have both an IPv4 and IPv6 address, separated by commas. Note if you only set an IPv6 Wireguard address, no IPv4 traffic will be allowed through which will have undesired effects.

4. Test your setup:
    1. Launch your docker-compose stack
    1. Run the following command:

        ```sh
        sudo docker exec -t gluetun sh -c "apk add curl && curl -6 --silent https://ipv6.ipleak.net/json/"
        ```

        which should show the IPv6 address of the VPN server.
