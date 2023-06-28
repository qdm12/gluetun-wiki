# Connect a container to Gluetun

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.setup.connect-to-gluetun)

There are various ways to connect a container to Gluetun.

💡 If you are connecting containers to Gluetun's network stack, you might want to also check the [Port mapping page](port-mapping.md) to know how to access ports of containers connected to Gluetun.

## Container in the same docker-compose.yml

Add `network_mode: "service:gluetun"` to your second container so that it uses the `gluetun` network stack.

There is no need for `depends_on`.

## External container to Gluetun

Add `--network=container:gluetun` when launching the container, provided Gluetun is already running.

## Container in another docker-compose.yml

Add `network_mode: "container:gluetun"` to your *docker-compose.yml*, provided Gluetun is already running.
