#!/usr/bin/env bash
set -o errexit -o nounset

image=$1
expectedGroovyVersion=$2

version=$(docker run --rm --volume "${PWD}:/scripts" --workdir "/scripts" "${image}" groovy printVersion.groovy)
if [ "${version}" != "${expectedGroovyVersion}" ]; then
    echo "version '${version}' does not match expected version '${expectedGroovyVersion}'"
    exit 1
fi

echo "All tests succeeded"
