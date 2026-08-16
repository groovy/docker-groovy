#!/usr/bin/env bash

set -o errexit -o nounset -o pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$script_dir/version-utils.sh"

_sed() {
  if sed --version > /dev/null 2>&1; then
    # GNU sed
    sed --regexp-extended --in-place "$@"
  else
    # BSD sed
    sed -Ei '' "$@"
  fi
}

tags=$(curl -s 'https://api.github.com/repos/apache/groovy/tags?per_page=100')

for majorVersion in 3 4 5 6; do
  groovyTag=$(echo "$tags" | grep -Eo "GROOVY_${majorVersion}_[0-9]{1,2}_[0-9]{1,2}(_(ALPHA|BETA|RC)_[0-9]+)?" | head -n 1)
  groovyVersion=$(normalize_groovy_version "$groovyTag")
  echo "Updating Groovy ${majorVersion} to ${groovyVersion}"

  _sed "s/ENV GROOVY_VERSION=.+/ENV GROOVY_VERSION=${groovyVersion}/" "groovy-${majorVersion}/"*/Dockerfile
done
