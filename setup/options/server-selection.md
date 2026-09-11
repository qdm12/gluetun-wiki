# Server selection

## Environment variables

Other variables such as `SERVER_COUNTRIES` are available, depending on the VPN provider.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `SERVER_SELECTION_MODE` | `random` | `random` or `ordered` | `random` shuffles filtered servers to pick from. `ordered` uses the order of the filtered servers as is (see [this commit](https://github.com/passteque/gluetun/commit/5a5788cd3f940af6dea02ea3e3c353e35a2d1edd)). |
