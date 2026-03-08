# Inter-containers networking

## Between Gluetun-connected containers

Containers connected to Gluetun are under the same network host (Gluetun).

Therefore, they should reach each other through `localhost` (or `127.0.0.1`) on the right port.

Note two containers cannot listen on the same port in this case, there is no workaround.
You might have to reach out to the program author to have a configurable listening port to avoid conflicts.

## Between a Gluetun-connected container and another container in the same network as Gluetun

For the purpose of this explanation:

- The Gluetun-connected container is named `A` and listens on port `5678`
- The non-Gluetun-connected container is named `B` and listens on port `8765`.

Container `B` should be able to reach container `A` by using `gluetun:5678`.
There is no need to publish ports on Gluetun in this case.

Similarly, container `A` should be able to reach container `B` by using `B:8765` (since v3.41)

Before v3.41, I recommend you to check out the Wiki for previous versions.
