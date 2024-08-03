# OpenVPN options

## Environment variables

If using OpenVPN, the following two are usually compulsory:

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `OPENVPN_USER` | | | OpenVPN username |
| `OPENVPN_PASSWORD` | | | OpenVPN password |

💁 The following environment variables are all optional.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `OPENVPN_PROTOCOL` | `udp` | `udp` or `tcp` | Network protocol to use, only valid for OpenVPN |
| `OPENVPN_VERSION` | `2.6` | `2.5` or `2.6` | Set the OpenVPN version to run |
| `OPENVPN_ENDPOINT_IP` |  | Valid IP address | Specify a generally optional target VPN server IP address to use |
| `OPENVPN_ENDPOINT_PORT` | | Valid port number | Specify a generally optional target VPN server port number to use |
| `OPENVPN_VERBOSITY` | `1` | `0` to `6` | Openvpn verbosity level |
| `OPENVPN_FLAGS` | | Openvpn flags | Space delimited openvpn flags to pass to `openvpn` |
| `OPENVPN_ROOT` | `no` | `yes` or `no` | Run OpenVPN as root |
| `OPENVPN_CIPHERS` | | i.e. `aes-256-gcm` | Specify a custom cipher to use. It will also set `ncp-disable` if using AES GCM for PIA |
| `OPENVPN_AUTH` | | i.e. `sha256` | Specify a custom auth algorithm to use |
| `OPENVPN_MSSFIX` | `0` | `0` to `9999` | Set the MSS fix parameter. Set to `0` to use the defaults. |
| `OPENVPN_CERT` | | base64 PEM | OpenVPN certificate content (base64 part only) |
| `OPENVPN_KEY` | | base64 PEM | OpenVPN key (base64 part only) |
| `OPENVPN_ENCRYPTED_KEY` | | base64 PEM | OpenVPN encrypted key (base64 part only) |
| `OPENVPN_KEY_PASSPHRASE` | | | Specify a key passphrase to decrypt an encrypted key |
| `OPENVPN_PROCESS_USER` | `root` | Valid OS user | Specify a user to run the OpenVPN subprocess |
| `OPENVPN_CUSTOM_CONFIG` | | Empty or path to file | Specify a custom OpenVPN configuration file to use for [the custom VPN provider](../providers/custom.md). |
