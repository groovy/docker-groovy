#!/usr/bin/env bash
set -o errexit -o nounset

image=$1
expectedGroovyVersion=$2

if [[ $(id -u) -eq "1000" ]]; then
    user="groovy"
    home="/home/groovy"
else
    user="root"
    home="/root"
fi

version=$(docker run --user "${user}" --rm "${image}" groovy -e "println GroovySystem.version")
if [[ "${version}" != "${expectedGroovyVersion}" ]]; then
    echo "version '${version}' does not match expected version '${expectedGroovyVersion}'" >&2
    exit 1
fi

case "$(uname -s)" in
  CYGWIN*|MINGW32*|MSYS*|MINGW*)
    pwd=$(cygpath --windows "${PWD}")
    ;;
  *)
    pwd="${PWD}"
    ;;
esac
if ! docker run --user "${user}" --rm --volume "${pwd}:${home}/scripts" --workdir "${home}/scripts" "${image}" groovy grape.groovy; then
    echo "No Grape cached files found" >&2
    exit 1
fi

echo "All tests succeeded"
