# Wireguard

## Implementation

The Wireguard implementation will be your Kernel Wireguard implementation if it is present. Otherwise, the Go user space Wireguard implementation is used, which is based on imported packages from [git.zx2c4.com/wireguard-go](https://git.zx2c4.com/wireguard-go).

### Performance

Wireguard is often known as *so much faster* than OpenVPN. Let's find out!

- Gluetun `v3.24.0` is used
- The Mullvad VPN service provider is used
- Gluetun is connected to the closest VPN server. This is to better measure the performance of the protocol, instead of the various bandwidth bottlenecks on a further away server.
- The following command is used to measure bandwidth performance:

    ```sh
    docker run -it --rm --network=container:gluetun alpine:3.20 /bin/sh -c "apk add speedtest-cli && speedtest-cli"
    ```

| Host OS | CPU | CPU arch | CPU cores | Protocol | Download Mbps | Upload Mbps | Wireguard download increase | Wireguard upload increase |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Windows with Docker desktop on WSL2 | AMD 5900x | `amd64` | `12` | OpenVPN | `299.24` | `463.69` | | |
| Windows with Docker desktop on WSL2 | AMD 5900x | `amd64` | `12` | Wireguard | `298.55` | `493.49` | -0.23% | +5% |
| Arch Linux | AMD 2600x | `amd64` | `6` | OpenVPN | `645.91` | `481.25` | | |
| Arch Linux | AMD 2600x | `amd64` | `6` | Wireguard | `673.37` | `561.28` | +4.2% | +16.6% |
| Raspbian (32 bit) | Raspberry Pi 4 A72 | `arm64` | `4` | OpenVPN | `50` | `10` | | |
| Raspbian (32 bit) | Raspberry Pi 4 A72 | `arm64` | `4` | Wireguard | `57` | `10` | `+14%` | `+0%` |

Conclusions:

- Docker desktop on Windows sucks network performance wise 😆
- On the usual amd64 CPUs, Wireguard is only 4.2% faster than OpenVPN (comparing the 2 maximum bandwidths `645.91` and `673.37`)
- On low power devices such as Raspberry Pis, the performance jump is more significant, with a 14% download bandwidth increase over OpenVPN (tested by [@granroth](https://github.com/granroth))

Further investigations:

- [ ] Does Wireguard have a bigger impact on many cores and low single thread performance CPUs?
