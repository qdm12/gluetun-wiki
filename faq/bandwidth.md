# Bandwidth speeds

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.faq.bandwidth)

You might wonder why your bandwidth is slower in certain situations.

I ran multiple tests using different clients, servers and regions to clarify all this.

## Conclusions

- The further away the VPN server is, the slower the bandwidth will be
- Running Docker on a VM/Windows/OSX brings a serious bottleneck due to virtualization
- The VPN protocol (`VPN_TYPE=openvpn` or `VPN_TYPE=wireguard`):
  - `wireguard` is almost always slower than `openvpn`, maybe due to server load.
  - `wireguard` does have a more significant impact on low power devices (+15% speeds)
- Wireguard running in the kernel space can bring significant gains, depending on the device (see [this report](https://github.com/qdm12/gluetun/issues/134#issuecomment-1500962965))
- VPN server for OpenVPN and Wireguard are often not the same even for the same location, and so have different server load
- The speedtest server can give very different results over time
- The difference of results from one speedtest server to another (even in the same city) can be largely different
- Bandwidth fluctuates during the day due to other VPN clients on a particular server
- Some VPN providers may:
  - throttle down the download bandwidth when you run a speedtest (e.g. Mullvad)
  - allocate you less bandwidth if you don't use their proprietary software
- Docker might be a bandwidth bottleneck, compared to Pods (see below bjoli's investigation)

### Investigations

- Running OpenVPN **or** Wireguard natively on Windows gives higher bandwidths than when using a container on a Linux host. This is even stranger since Wireguard is supported, since its implementation is the same one for both Gluetun and the Wireguard Windows client. My only explanation is that Docker causes a bottleneck. **This should be investigated once gluetun can be run out of a container as a binary**.

💁 [@bjoli](https://github.com/bjoli) [reported](https://github.com/qdm12/gluetun-wiki/issues/54) that running Gluetun and other containers in the same Pod using Podman gives great bandwidth results! So this might all be due to simply Docker.

💁

## Testing

### Setup

- I'm based in Montreal Canada
- My bandwidth without VPN is around 1Gbps up and down.
- Gluetun `v3.24.0` is used
- The Mullvad VPN service provider is used
- We test on multiple machines:

    | Nickname | Host OS | Docker | CPU | CPU arch | CPU virtual cores |
    | --- | --- | --- | --- | --- | --- |
    | `windows` | Windows | Docker desktop on WSL2 | AMD 5900x | `amd64` | `24` |
    | `arch` | Arch Linux | Docker | AMD 2600x | `amd64` | `12` |

- We use `speedtest-cli` to test the bandwidth on all speedtest hosts with:

    ```sh
    speedtest-cli --no-upload --server <server-id>
    ```

    On Windows I use: `speedtest -s <server-id>`

- We use the following Speedtest servers

    | Nickname | ID | Name | Distance to VPN server |
    | --- | --- | --- | --- |
    | `amsterdam` | `26425` | ExtraIP (Amersfoort, Netherlands) | 41.77 km |
    | `montreal` | `4393` | TELUS (Montreal, QC, Canada) | 0.35 km |

### Results

*Note: `native` client host means we run the Windows program without Docker.*

| VPN server | Speedtest server | Machine | VPN client host | Speedtest host | Protocol | Highest of 3 download Mbps |
| --- | --- | --- | --- | --- | --- | --- |
| `nl-ams-001` | `amsterdam`  | `arch` | `gluetun` | `gluetun` | `openvpn` | `110` |
| `nl1-wireguard` | `amsterdam` | `arch` | `gluetun` | `gluetun` | `wireguard` | `85` |
| `nl-ams-001` | `amsterdam`  | `windows` | `gluetun` | `gluetun` | `openvpn` | `54` |
| `nl1-wireguard` | `amsterdam` | `windows` | `gluetun` | `gluetun` |  `wireguard` | `42`  |
| `nl-ams-001` | `amsterdam`  | `windows` | native | native | `openvpn` | `206` |
| `nl1-wireguard` | `amsterdam` | `windows` | native | native | `wireguard` | `115` |
| `ca-mtr-101` | `montreal` | `arch` | `gluetun` | `gluetun` | `openvpn` | `310` |
| `ca10-wireguard` | `montreal` | `arch` | `gluetun` | `gluetun` | `wireguard` | `310` |
| `ca-mtr-101` | `montreal` | `windows` | `gluetun` | `gluetun` | `openvpn` | `194` |
| `ca10-wireguard` | `montreal` | `windows` | `gluetun` | `gluetun` |  `wireguard` | `210` |
| `ca-mtr-101` | `montreal` | `windows` | native | native | `openvpn` | `530` |
| `ca10-wireguard` | `montreal` | `windows` | native | native | `wireguard` | `512` |
