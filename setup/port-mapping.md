# Port mapping

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.setup.port-mapping)

You can access ports of containers connected to gluetun by port mapping ports on the `gluetun` container.

For example, to access port `9000` of container `xyz` connected to Gluetun, publish port `9000:9000` for the Gluetun container and access it at localhost:9000.

The corresponding docker-compose.yml would look like:

```yml
version: '3'
services:
  gluetun:
    image: qmcgaw/gluetun
    container_name: gluetun
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun:/dev/net/tun
    environment:
      - OPENVPN_USER=js89ds7
      - OPENVPN_PASSWORD=8fd9s239G
    ports:
      - 9000:9000/tcp
  xyz:
    image: xyz
    container_name: xyz
    network_mode: "service:gluetun"
```

💁 To run multiple instances of the same container image through Gluetun, you need to configure each instance to listen on a different port **internally**, or it would conflict. This is possible for example with Deluge, but not with some Transmission images. You can however create an issue on the relevant repository for maintainers to implement this, since it's usually rather easy to code.
