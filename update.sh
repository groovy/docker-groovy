#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

groovyVersion=${1}

sed --regexp-extended --in-place "s/ENV GROOVY_VERSION .+/ENV GROOVY_VERSION ${groovyVersion}/" ./*/Dockerfile
sed --regexp-extended --in-place "s/expectedGroovyVersion: .+$/expectedGroovyVersion: ${groovyVersion}/" .github/workflows/ci.yaml
