#!/usr/bin/env bash
set -e

groovyMajorVersion=2.4
groovyVersion=${groovyMajorVersion}.8

cd jre7
docker build -t apache/groovy:jre7-${groovyMajorVersion} -t apache/groovy:jre7-${groovyVersion} -t apache/groovy:jre7-latest .
cd ../jdk7
docker build -t apache/groovy:jdk7-${groovyMajorVersion} -t apache/groovy:jdk7-${groovyVersion} -t apache/groovy:jdk7-latest .
cd ../jre7-alpine
docker build -t apache/groovy:jre7-${groovyMajorVersion}-alpine -t apache/groovy:jre7-${groovyVersion}-alpine -t apache/groovy:jre7-latest-alpine .
cd ../jdk7-alpine
docker build -t apache/groovy:jdk7-${groovyMajorVersion}-alpine -t apache/groovy:jdk7-${groovyVersion}-alpine -t apache/groovy:jdk7-latest-alpine .

cd ../jre8
docker build -t apache/groovy:jre8-${groovyMajorVersion} -t apache/groovy:jre8-${groovyVersion} -t apache/groovy:jre8-latest .
cd ../jdk8
docker build -t apache/groovy:jdk8-${groovyMajorVersion} -t apache/groovy:jdk8-${groovyVersion} -t apache/groovy:jdk8-latest .
cd ../jre8-alpine
docker build -t apache/groovy:jre8-${groovyMajorVersion}-alpine -t apache/groovy:jre8-${groovyVersion}-alpine -t apache/groovy:jre8-latest-alpine .
cd ../jdk8-alpine
docker build -t apache/groovy:jdk8-${groovyMajorVersion}-alpine -t apache/groovy:jdk8-${groovyVersion}-alpine -t apache/groovy:jdk8-latest-alpine .

cd ..
