#!/usr/bin/env bash
set -e

groovyMajorVersion=2.4
groovyVersion=${groovyMajorVersion}.8

cd ../jdk7
docker build \
     -t apache/groovy:jdk7-${groovyMajorVersion} \
     -t apache/groovy:jdk7-${groovyVersion} \
     -t apache/groovy:jdk7-latest \
     .

cd jre7
docker build \
     -t apache/groovy:jre7-${groovyMajorVersion} \
     -t apache/groovy:jre7-${groovyVersion} \
     -t apache/groovy:jre7-latest \
     .

cd ../jdk7-alpine
docker build \
     -t apache/groovy:jdk7-${groovyMajorVersion}-alpine \
     -t apache/groovy:jdk7-${groovyVersion}-alpine \
     -t apache/groovy:jdk7-alpine \
     .

cd ../jre7-alpine
docker build \
     -t apache/groovy:jre7-${groovyMajorVersion}-alpine \
     -t apache/groovy:jre7-${groovyVersion}-alpine \
     -t apache/groovy:jre7-alpine \
     .

cd ../jdk8
docker build \
     -t apache/groovy:jdk8-${groovyMajorVersion} \
     -t apache/groovy:jdk8-${groovyVersion} \
     -t apache/groovy:jdk8-latest \
     -t apache/groovy:jdk-${groovyMajorVersion} \
     -t apache/groovy:jdk-${groovyVersion} \
     -t apache/groovy:jdk-latest \
     .

cd ../jre8
docker build \
     -t apache/groovy:jre8-${groovyMajorVersion} \
     -t apache/groovy:jre8-${groovyVersion} \
     -t apache/groovy:jre8-latest \
     -t apache/groovy:jre-${groovyMajorVersion} \
     -t apache/groovy:jre-${groovyVersion} \
     -t apache/groovy:jre-latest \
     -t apache/groovy:${groovyMajorVersion} \
     -t apache/groovy:${groovyVersion} \
     -t apache/groovy:latest \
     .

cd ../jdk8-alpine
docker build \
     -t apache/groovy:jdk8-${groovyMajorVersion}-alpine \
     -t apache/groovy:jdk8-${groovyVersion}-alpine \
     -t apache/groovy:jdk8-alpine \
     -t apache/groovy:jdk-${groovyMajorVersion}-alpine \
     -t apache/groovy:jdk-${groovyVersion}-alpine \
     -t apache/groovy:jdk-alpine \
     .

cd ../jre8-alpine
docker build \
     -t apache/groovy:jre8-${groovyMajorVersion}-alpine \
     -t apache/groovy:jre8-${groovyVersion}-alpine \
     -t apache/groovy:jre8-alpine \
     -t apache/groovy:jre-${groovyMajorVersion}-alpine \
     -t apache/groovy:jre-${groovyVersion}-alpine \
     -t apache/groovy:jre-alpine \
     -t apache/groovy:${groovyMajorVersion}-alpine \
     -t apache/groovy:${groovyVersion}-alpine \
     -t apache/groovy:alpine \
     .

cd ..
