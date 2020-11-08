#!/usr/bin/env bash
set -o errexit -o nounset

groovyVersion=${1}

sed --regexp-extended --in-place "s/ENV GROOVY_VERSION .+/ENV GROOVY_VERSION ${groovyVersion}/" */Dockerfile
sed --regexp-extended --in-place "s/expectedGradleVersion: .+$/expectedGradleVersion: ${gradleVersion}/" .github/workflows/ci.yaml
