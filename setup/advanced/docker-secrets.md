# Docker secrets

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.setup.docker-secrets)

💁 Note this is **a bit pointless**, since gluetun already takes care of unsetting sensitive environment variables after reading them at start.

If you use Docker Compose or Docker Swarm, you can optionally use [Docker secret files](https://docs.docker.com/engine/swarm/secrets/) for all sensitive values such as your Openvpn credentials, instead of using environment variables.

The following secrets can be used:

- `openvpn_user`
- `openvpn_password`
- `openvpn_clientkey`
- `openvpn_encrypted_key`
- `openvpn_key_passphrase`
- `openvpn_clientcrt`
- `wireguard_conf`
- `wireguard_private_key`
- `wireguard_preshared_key`
- `wireguard_addresses`
- `httpproxy_user`
- `httpproxy_password`
- `shadowsocks_password`

Note that you can change the secret file path in the container by changing the environment variable in the form `<capitalizedSecretName>_SECRETFILE`.
For example, `OPENVPN_PASSWORD_SECRETFILE` defaults to `/run/secrets/openvpn_password` which you can change.
