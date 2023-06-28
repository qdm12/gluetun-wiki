# Shadowsocks options

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `SHADOWSOCKS` | `off` | `on`, `off` | Enable the internal Shadowsocks proxy |
| `SHADOWSOCKS_LOG` | `off` | `on`, `off` | Enable logging |
| `SHADOWSOCKS_LISTENING_ADDRESS` | `:8388` | Listening address | Internal listening address for Shadowsocks |
| `SHADOWSOCKS_PASSWORD` | |  | Password to use to connect to Shadowsocks |
| `SHADOWSOCKS_CIPHER` | `chacha20-ietf-poly1305` | `chacha20-ietf-poly1305`, `aes-128-gcm`, `aes-256-gcm` | AEAD Cipher to use for Shadowsocks |
