# groovy-docker
This is the Git repo that will eventually (hopefully) become the official Docker images for Groovy.

## Instructions for use
For now, you'll have to build the images first until they're published on Docker Hub.

### Starting Groovsh
`docker run -it --rm --name groovy apache/groovy:jre8-latest-alpine`

### Running a Groovy script
`docker run -it --rm -v "$PWD":/scripts -w /scripts --name groovy apache/groovy:jre8-latest-alpine groovy <script> <script-args>`

## Instructions for a new Groovy release
1. Change `ENV GROOVY_VERSION` in all Dockerfiles to new version number.
1. Change `groovyVersion` (and `groovyMajorVersion` if applicable) variable(s) in _buildImages.sh_ to new version number(s).
1. Download the binary zip.
1. Run `sha256sum` on the above zip and change the `ENV GROOVY_DOWNLOAD_SHA256` in all Dockerfiles to new sha.
1. Run _buildImages.sh_

### Prerequisites
* Docker
* sha256sum
