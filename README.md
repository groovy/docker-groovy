# groovy-docker
This is the Git repo that will eventually (hopefully) become the official images for Groovy.

## Instructions for a new Groovy release
1. Change `ENV GROOVY_VERSION` in all Dockerfiles to new version number.
1. Change `groovyVersion` variable in _buildImages.sh_ to new version number.
1. Download the binary zip.
1. Run `sha256sum` on the above zip and change the `ENV GROOVY_DOWNLOAD_SHA256` in all Dockerfiles to new sha.
1. Run _buildImages.sh_

## Prerequisites
* Docker
* sha256sum
