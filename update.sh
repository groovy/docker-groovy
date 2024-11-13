#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

_sed() {
  if sed --version; then
    # GNU sed
    sed --regexp-extended --in-place "$@"
  else
    # BSD sed
    sed -Ei '' "$@"
  fi
}

groovyVersion=$(curl -s 'https://api.github.com/repos/apache/groovy/tags' | grep -Eo 'GROOVY_4.[0-9]{1,2}.[0-9]{1,2}' | head -n 1 | sed -e 's/GROOVY_//' -e 's/_/./g')
echo "Updating to Groovy $groovyVersion"

_sed "s/ENV GROOVY_VERSION=.+/ENV GROOVY_VERSION=${groovyVersion}/" ./*/Dockerfile
_sed "s/expectedGroovyVersion: .+$/expectedGroovyVersion: ${groovyVersion}/" .github/workflows/ci.yaml
