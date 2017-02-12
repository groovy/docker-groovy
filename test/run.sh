#!/usr/bin/env bash
set -eu

image=$1
expectedGroovyVersion=$2

version=$(docker run --rm -v "${PWD}:/scripts" -w "/scripts" "${image}" groovy printVersion.groovy)
if [ "${version}" != "${expectedGroovyVersion}" ]; then
    echo "version '${version}' does not match expected version '${expectedGroovyVersion}'"
    exit 1
fi

echo "All tests succeeded"
