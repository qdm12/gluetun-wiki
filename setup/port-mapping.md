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
