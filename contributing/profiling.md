# Profiling

Since Gluetun is written in Go, you can relatively easily profile its performance.
Note however this does not cover profiling OpenVPN nor Wireguard running in kernelspace.

In the following, we assume:

- Gluetun runs on a server, *'your server'*, with IP address `192.168.1.2`
- You have a computer with a screen, *'your computer'*, which can access your server at `192.168.2.2`

Follow these steps, adjusting the IP addresses to your needs:

1. On your computer, install [Go](https://go.dev/dl/)
1. On your server, run Gluetun with port mapping `6060:6060/tcp` and set the environment variable `PPROF_ENABLED=yes`.
1. On your computer, run one of the following commands, which will open your browser to [http://localhost:8000](http://localhost:8000/):
    - Profile heap memory

        ```sh
        go tool pprof -http=localhost:8000 http://192.168.2.2:6060/debug/pprof/heap
        ```

    - Profile CPU for 30s

        ```sh
        go tool pprof -http=localhost:8000 http://192.168.2.2:6060/debug/pprof/profile
        ```

You can further configure the pprof server with the following environment variables:

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `PPROF_HTTP_SERVER_ADDRESS` | `:6060` | Listening address | Pprof http server listening address |
| `PPROF_BLOCK_PROFILE_RATE` | `0` | Positive integer | Block profile rate, set to `0` to disable |
| `PPROF_MUTEX_PROFILE_RATE` | `0` | Positive integer | Mutex profile rate, set to `0` to disable |
