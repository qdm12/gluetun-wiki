# Inter-containers networking

## Between Gluetun-connected containers

Containers connected to Gluetun are under the same network host (Gluetun).

Therefore, they should reach each other through `localhost` (or `127.0.0.1`) on the right port.

Note two containers cannot listen on the same port in this case, there is no workaround.
You might have to reach out to the program author to have a configurable listening port to avoid conflicts.

## Between a Gluetun-connected container and another container

For the purpose of this explanation:

- The Gluetun-connected container is named `A` and listens on port `5678`
- The non-Gluetun-connected container is named `B` and listens on port `8765`.

First of all, both Gluetun and `B` must be in the same Docker network.
You can check this with:

```sh
docker inspect gluetun -f "{{json .NetworkSettings.Networks }}"
docker inspect B -f "{{json .NetworkSettings.Networks }}"
```

Container `B` should be able to reach container `A` by using `gluetun:5678`.
There is no need to publish ports on Gluetun in this case.

On the other hand, container `A` cannot reach container `B` by using `B:8765`.
This is due to the current DNS over TLS server which does not communicate with the Docker network DNS server.
As a consequence, resolution of containers does not work from Gluetun.
You can subscribe to [#281](https://github.com/qdm12/gluetun/issues/281) to know when this is resolved.

The current workaround is to use an IP address to reach `B`:

1. Create a new bridged network

    ```sh
    docker network create --subnet=172.18.0.0/16 gluetun_network
    ```

2. In your `B` container definition, specify to use this network together with a fixed IP address:

    ```sh
    docker run --net gluetun_network --ip 172.18.0.22 an/imagename:tag
    ```

    or for docker-compose.yml:

    ```yml
    version: '3'
    services:
      B:
        image: an/imagename:tag
        networks:
          gluetun_network:
            ipv4_address: 172.18.0.22

    networks:
      gluetun_network:
        external: true
    ```

3. Change the Gluetun container definition such that it uses the new network `gluetun_network`:

    ```sh
    docker run --net gluetun_network ... qmcgaw/gluetun
    ```

    or for docker-compose.yml:

    ```yml
    version: '3'
    services:
      gluetun:
        image: qmcgaw/gluetun
        # ...
        networks:
          gluetun_network:

    networks:
      gluetun_network:
        external: true
    ```

    Note you do not have to specify a fixed IP address here.

4. You can now access container `B:8765` from the Gluetun-connected container `A` by using `172.18.0.22:8765`.
