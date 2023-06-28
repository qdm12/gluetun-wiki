# Project structure

## Introduction

Gluetun's entrypoint is the `main()` function in the Go file [cmd/main.go](https://github.com/qdm12/gluetun/blob/master/cmd/gluetun/main.go).

The rest of the code lives in:

- the [internal directory](https://github.com/qdm12/gluetun/tree/master/internal)
- the [`qdm12/dns` package](https://github.com/qdm12/dns)
- the [`qdm12/ss-server` package](https://github.com/qdm12/ss-server)
