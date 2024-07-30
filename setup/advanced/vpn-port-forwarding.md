# VPN server port forwarding

💁 Each VPN service provider supporting port forwarding have their own section on their own page on how to set it up.

🔴 This is **NOT** about [Docker port mapping](../port-mapping.md)

## Native integrations

VPN server side port forwarding is implemented natively into Gluetun for the following providers:

- **Private Internet Access**, [more information](../providers/private-internet-access.md)
- **ProtonVPN**, [more information](../providers/protonvpn.md)

You can enable it with `VPN_PORT_FORWARDING=on`.
The forwarded port can be accessed:

- through the [control server](control-server.md#openvpn-and-wireguard)
- through the file written at `/tmp/gluetun/forwarded_port` (will be deprecated in v4.0.0 release)

## Allow a forwarded port through the firewall

For non-native integrations where you have a designated forwarded port from your VPN provider, you can allow it by adding it to the environment variable `FIREWALL_VPN_INPUT_PORTS`.

## Test it

Assuming:

- your gluetun container name is `gluetun`
- your VPN public IP address is `99.99.99.99`
- your VPN port forwarded is `4567`

You can test it with:

```sh
docker exec -it gluetun /bin/sh
# Change amd64 to your CPU architecture
wget -qO port-checker https://github.com/qdm12/port-checker/releases/download/v0.3.0/port-checker_0.3.0_linux_amd64
chmod +x port-checker
./port-checker -port 4567
```

Then in your browser, access [http://99.99.99.99:4567](http://99.99.99.99:4567).

It should show you your browser IP address and user agent.
You should also see the request logged in the port-checker output.

Finally, back to the terminal, press `CTRL+C` to stop port-checker and enter `exit` to quit the interactive shell in `gluetun`.
