# Docker image tags

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.faq.dockerimage)

If you use the default `qmcgaw/gluetun` image, you are technically using the Docker image with the `:latest` tag.
This image tag points to [the last commit of the master branch](https://github.com/qdm12/gluetun/commits/master/), which is the edge of development.
But if it becomes **broken**, then this page is for you!

## Release tags

ℹ️ [**Live list of recent image tags**](https://hub.docker.com/r/qmcgaw/gluetun/tags?page=1&page_size=&ordering=last_updated&name=v3)

[Multiple releases](https://github.com/qdm12/gluetun/releases) are made through time when the image is considered stable.

Each time a Github release is made, an associated Docker image tag is made, for example a `v3.1.0` release produces the image `qmcgaw/gluetun:v3.1.0`.

You can thus use one of these image tags if `:latest` doesn't work for you. Also, don't forget to [create an issue](https://github.com/qdm12/gluetun/issues/new/choose) for it 😉

Finally you can also use image tag `:v3` to get the latest stable release (for example `v3.28.2`),
although I would appreciate if you can use the latest image instead to detect issues faster.

## Why is `:latest` pointing to the edge of development?

Essentially, I favorise **release image tags (`v3.x.x`) stability** and **earlier fixes** over *having more users using the unstable version of the program*.

It is documented you can use the `:v3` image tag, in the section above as well as in the root page of the Wiki, but several users don't read this and keep using the `:latest` tag.
There is no `:dev` tag or similar, since I doubt many people would use it, and that would hurt the development process (see below).

Making users use the latest code is not a selfish and/or lazy approach, Gluetun needs a lot of *human testers* because:

- Gluetun is somehow coupled with the host system, kernel and network setup. This is nearly impossible to test automatically, especially given the limited development resources.
- Gluetun supports many providers, each with their own quirks and compatibility issues. Again, not really possible to test automatically.

On the bright side, my release process consists in:

1. Right after a release, and up to 1 month after the release, work on large changes that could possibly (hopefully not) break the latest program
1. Approximately 2 months after a release, focus on urgent bug issues
1. once all bugs are fixed, wait a week and do not touch the code, to see if a bug issue is reported
1. if no bug issue is reported, release the new version

Which hence creates rather stable releases.

More debates on this topic: [#556](https://github.com/qdm12/gluetun/issues/556), [#2387](https://github.com/qdm12/gluetun/issues/2387#issuecomment-2262051998)
