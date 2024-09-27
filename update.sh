#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

groovyVersion=$(curl -s 'https://api.github.com/repos/apache/groovy/tags' | grep -Eo 'GROOVY_4.[0-9]{1,2}.[0-9]{1,2}' | head -n 1 | sed -e 's/GROOVY_//' -e 's/_/./g')
echo "Updating to Groovy $groovyVersion"

sed --regexp-extended --in-place "s/ENV GROOVY_VERSION=.+/ENV GROOVY_VERSION=${groovyVersion}/" ./*/Dockerfile
sed --regexp-extended --in-place "s/expectedGroovyVersion: .+$/expectedGroovyVersion: ${groovyVersion}/" .github/workflows/ci.yaml
