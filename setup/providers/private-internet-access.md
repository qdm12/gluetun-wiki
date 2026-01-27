# Private Internet Access

## OpenVPN

```sh
docker run -it --rm --cap-add=NET_ADMIN --device /dev/net/tun \
-e VPN_SERVICE_PROVIDER="private internet access" \
-e OPENVPN_USER=abc -e OPENVPN_PASSWORD=abc \
-v /yourpath/gluetun:/gluetun \
-e SERVER_REGIONS=Netherlands qmcgaw/gluetun
```

```yml
version: "3"
services:
  gluetun:
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun:/dev/net/tun
    volumes:
      - ./gluetun:/gluetun
    environment:
      - VPN_SERVICE_PROVIDER=private internet access
      - OPENVPN_USER=abc
      - OPENVPN_PASSWORD=abc
      - SERVER_REGIONS=Netherlands
```

### Required environment variables

- `VPN_SERVICE_PROVIDER=private internet access`
- `OPENVPN_USER`
- `OPENVPN_PASSWORD`

### Optional environment variables

- `SERVER_REGIONS`: Comma separated list of regions
- `SERVER_NAMES`: Comma separated list of server names
- `SERVER_HOSTNAMES`: Comma separated list of server hostnames. Beware this is the narrowest filter, so if you set this to a single hostname and this hostname disappears from the Gluetun servers data due to an update, your container will no longer work until this filter is changed. I would suggest avoiding it unless you know this reliability risk.
- `PORT_FORWARD_ONLY`: Set to `true` to select servers with port forwarding only
- `PRIVATE_INTERNET_ACCESS_OPENVPN_ENCRYPTION_PRESET`: Encryption preset, defaulting to `strong`, which can be set to `normal`, `strong` or `none`. ⚠️ `none` disables the `cipher` and `auth` OpenVPN options.
- `OPENVPN_ENDPOINT_PORT`: Custom OpenVPN server endpoint port
- `VPN_PORT_FORWARDING`: defaults to `off` and can be set to `on` to enable port forwarding on the VPN server

## Wireguard

💁 For now, native support cannot be added, but this is a slow work in progress.

In the meantime, [@Kieros](https://github.com/Kieros) proposes to use [kylegrantlucas/pia-wg-config](https://github.com/kylegrantlucas/pia-wg-config) to extract a Wireguard configuration file which you can then use with the [custom provider](custom.md#wireguard).

For VPN server port fowarding with Wireguard, you need to set:

- `VPN_PORT_FORWARDING=on`
- `VPN_PORT_FORWARDING_PROVIDER=private internet access`
- `VPN_PORT_FORWARDING_USERNAME=yourusername`
- `VPN_PORT_FORWARDING_PASSWORD=yourpassword`
- `SERVER_NAMES=ca-toronto.privacy.network` #or whichever location is needed - note port forwarding is disabled on US servers

To get the server_names field you need, run command like `docker run --rm qmcgaw/gluetun format-servers -private-internet-access | grep toronto` to get the following list of servers for toronto. Using the unique server names instead of the domain name caused gluetun to reconnect repeatedly, plus these server names will change over time. 
Sample output:
```
| CA Toronto | `ca-toronto.privacy.network` | toronto420 | ✅ | ✅ | ✅ |
| CA Toronto | `ca-toronto.privacy.network` | toronto421 | ✅ | ✅ | ✅ |
| CA Toronto | `ca-toronto.privacy.network` | toronto426 | ✅ | ✅ | ✅ |
```
## VPN server port forwarding

### Warning

In my experience, port forwarding with PIA is not really working for some reason. It seems to only work for p2p applications, PIA might be doing deep packet inspection on the forwarded port.

From [@ddelange](https://github.com/ddelange) on issue [#464](https://github.com/qdm12/gluetun/issues/464#issuecomment-1091966502), further confirming this:

> PIA replied that their service does not support incoming connections over a forwarded port.
> I also don't understand the answer (I was asking specifically about hosting a webserver on the forwarded port), because incoming connections on the forwarded port seem to work fine e.g. for P2P protocols

### Setup

First refer to the [VPN server port forwarding setup page](../advanced/vpn-port-forwarding.md#native-integrations).

Once enabled, you will keep the same forwarded port for 60 days as long as you bind mount the `/gluetun` directory. It will be automatically refreshed.

### Sample of working config:
```yml
- VPN_SERVICE_PROVIDER=custom
- VPN_TYPE=wireguard
- WIREGUARD_PRIVATE_KEY=  #from pia-wg-config file
- WIREGUARD_PUBLIC_KEY=  #from pia-wg-config file
- WIREGUARD_ADDRESSES=  #from pia-wg-config file
- WIREGUARD_ENDPOINT_IP=  #from pia-wg-config file
- WIREGUARD_ENDPOINT_PORT=  #from pia-wg-config file
- VPN_PORT_FORWARDING=on
- VPN_PORT_FORWARDING_PROVIDER=private internet access
- VPN_PORT_FORWARDING_USERNAME=  #your PIA account
- VPN_PORT_FORWARDING_PASSWORD=  #your PIA password
- SERVER_NAMES=ca-toronto.privacy.network  #or whichever site needed - note port forwarding is disabled on US servers
- DNS_ADDRESS=  #from pia-wg-config file
- DNS_ADDRESS=  #from pia-wg-config file
```

### Deluge

[@jawilson](https://github.com/jawilson) developed a plugin to automagically update the forwarded port in Deluge: [**deluge-piaportplugin**](https://github.com/jawilson/deluge-piaportplugin)

## Servers

To see a list of servers available, [list the VPN servers with Gluetun](../servers.md#list-of-vpn-servers).
