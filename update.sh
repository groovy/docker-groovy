#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

_sed() {
  if sed --version > /dev/null; then
    # GNU sed
    sed --regexp-extended --in-place "$@"
  else
    # BSD sed
    sed -Ei '' "$@"
  fi
}

for majorVersion in 3 4 5; do
  groovyVersion=$(curl -s 'https://api.github.com/repos/apache/groovy/tags?per_page=100' | grep -Eo "GROOVY_${majorVersion}.[0-9]{1,2}.[0-9]{1,2}" | head -n 1 | sed -e 's/GROOVY_//' -e 's/_/./g')
  echo "Updating Groovy ${majorVersion} to ${groovyVersion}"

  _sed "s/ENV GROOVY_VERSION=.+/ENV GROOVY_VERSION=${groovyVersion}/" "groovy-${majorVersion}/"*/Dockerfile
done
