# Development

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.contributing.development)

## Setup

### Getting the repository

1. Sign in or register for an account on [Github](https://github.com/)
1. [Fork Gluetun](https://github.com/qdm12/gluetun/fork) to your account.
1. Install [Git](https://git-scm.com/downloads)
1. Clone the repository either with https or ssh:

    ```sh
    # HTTPS
    git clone https://github.com/yourusername/gluetun.git
    # or SSH
    git clone git@github.com:yourusername/gluetun.git
    ```

1. Go to the newly cloned `gluetun` directory

### Development environment

Since Gluetun is for now tightly coupled with Linux's `unix` & `syscall` Go packages, you can develop it using one of the two options below:

#### Development container

The development Docker container for VSCode is pre-configured for Gluetun and works on OSX, Linux and Windows.

1. Install the following:
    1. [Docker](https://www.docker.com/products/docker-desktop/)
    1. [Docker Compose](https://docs.docker.com/compose/install/)
    1. [VS code](https://code.visualstudio.com/download)
    1. [VS code remote containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
1. Make sure the following exist and are accessible by Docker:
    - `~/.ssh` directory
    - `~/.gitconfig` file (can be empty)
1. Open the command palette in VS Code (CTRL+SHIFT+P).
1. Select `Remote-Containers: Open Folder in Container...` and choose the Gluetun project directory.

More information is available at [the development container readme](https://github.com/qdm12/gluetun/tree/master/.devcontainer#development-container)

#### Linux host setup

1. Install [Go](https://golang.org/dl/)
1. Download the dependencies

    ```sh
    go mod download
    ```

1. Install [golangci-lint](https://github.com/golangci/golangci-lint#install)
1. You might want to use an IDE such as VSCode with the [Go extension](https://marketplace.visualstudio.com/items?itemName=golang.go)
1. You might want to install [Docker](https://www.docker.com/products/docker-desktop/) to build and run the image.

## Modifying the code

Decide on a branch name for the feature you want to add, and then create that branch:

```sh
git checkout -b mybranchname
```

You can now start modifying the code and git commit your changes incrementally.

Before committing each commit, make sure the following passes:

```sh
# Linting
golangci-lint run
# Tests
go test ./...
```

💁 If you are new to Git and commits, you should read:

- [Using Pull Requests](https://help.github.com/articles/about-pull-requests/)
- [Github blog: write better commits, build better projects](https://github.blog/2022-06-30-write-better-commits-build-better-projects/)

To commit changes for example:

```sh
# Stage all new and changed files
git add .
# Commit the staged files
git commit -m "description of my changes"
```

You can also do this through IDE such as [VS Code source control](https://code.visualstudio.com/docs/editor/versioncontrol).

💡 **Want to add a VPN provider?** ➡️ [Add a provider](add-a-provider.md) - this is a detailed step-by-step guide.

💡 **Want to understand the project structure?** ➡️ [Project structure](project-structure.md)

## Testing the Docker container

1. Build the image with:

    ```sh
    docker build -t qmcgaw/gluetun .
    ```

1. Run it with:

    ```sh
    docker run -it --rm --cap-add=NET_ADMIN --device /dev/net/tun \
      -e VPN_SERVICE_PROVIDER=someprovider \
      -e VPN_TYPE=openvpn \
      -e OPENVPN_USER=test -e OPENVPN_PASSWORD=test \
      -p 8000:8000/tcp \
      qmcgaw/gluetun
    ```

## Final steps

1. Push your new branch to your forked repository:

    ```sh
    git push -u origin mybranchname
    ```

1. [Open a pull request on the `qdm12/gluetun` repository](https://github.com/qdm12/gluetun/compare)
1. I will most likely leave feedback as comments on the pull request, which you would have to address in order to get your work merged in the base repository. And also feel free to ask any question there!
