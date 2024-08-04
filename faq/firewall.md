# Firewall

The firewall takes care to only allow necessary network traffic to and from Gluetun.
It also effectively acts as a kill switch in case the VPN connection goes down, blocking all traffic.

## Default behavior

The firewall is rather strict by default:

- it drops any incoming traffic **except** from your Docker network on the (non VPN) default route found.
- it drops any outgoing traffic **except** to the combination VPN network interface + VPN server IP address + VPN server port + VPN server protocol.
- it drops any forwarding traffic

## Customization

The firewall can be adjusted, see the [Firewall options](../setup/options/firewall.md).

## Timing

Its setup happens at container start and takes about 15 milliseconds from start.
This cannot be reduced further, since setting the firewall rules already takes 10 milliseconds. It is also unlikely Docker connected containers would connect to Gluetun before it sets up its firewall, and the built-in proxies only get started after the firewall is enabled.

The firewall is never de-activated.

## Implementation details

The firewall for now uses `iptables` (`iptables-nft` preferred, and falls back on `iptables-legacy`) and `ip6tables` (`ip6tables-nft` preferred, and falls back on `ip6tables-legacy`), which are called using Go custom Go code using a subshell. Most of this code resides in the `internal/firewall` package.
