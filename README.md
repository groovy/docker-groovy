# docker-groovy

## Supported tags and respective Dockerfile links

* [jdk7](https://github.com/groovy/docker-groovy/blob/master/jdk7/Dockerfile)
* [jdk7-alpine](https://github.com/groovy/docker-groovy/blob/master/jdk7-alpine/Dockerfile)
* [jre7](https://github.com/groovy/docker-groovy/blob/master/jre7/Dockerfile)
* [jre7-alpine](https://github.com/groovy/docker-groovy/blob/master/jre7-alpine/Dockerfile)
* [jdk8, jdk](https://github.com/groovy/docker-groovy/blob/master/jdk8/Dockerfile)
* [jdk8-alpine, jdk-alpine](https://github.com/groovy/docker-groovy/blob/master/jdk8-alpine/Dockerfile)
* [latest, jre8, jre](https://github.com/groovy/docker-groovy/blob/master/jre8/Dockerfile)
* [alpine, jre8-alpine, jre-alpine](https://github.com/groovy/docker-groovy/blob/master/jre8-alpine/Dockerfile)
* [jdk9](https://github.com/groovy/docker-groovy/blob/master/jdk9/Dockerfile)
* [jre9](https://github.com/groovy/docker-groovy/blob/master/jre9/Dockerfile)

## What is Groovy?

[Apache Groovy](http://groovy-lang.org/) is a powerful, optionally typed and dynamic language, with static-typing and static compilation capabilities, for the Java platform aimed at improving developer productivity thanks to a concise, familiar and easy to learn syntax. It integrates smoothly with any Java program, and immediately delivers to your application powerful features, including scripting capabilities, Domain-Specific Language authoring, runtime and compile-time meta-programming and functional programming.

## How to use this image

### Starting Groovysh

`docker run -it --rm --name groovy groovy:latest`

### Running a Groovy script

`docker run --rm -v "$PWD":/scripts -w /scripts --name groovy groovy:latest groovy <script> <script-args>`

### Reusing the Grapes cache

The local Grapes cache can be reused across containers by creating a volume and mounting it in */home/groovy/.groovy/grapes*.

```
docker volume create --name grapes-cache
docker run -it -v grapes-cache:/home/groovy/.groovy/grapes groovy:alpine
```

## Instructions for a new Groovy release

1. Change `ENV GROOVY_VERSION` in all Dockerfiles to new version number.
1. Update _.travis.yml_.
1. Update [official-images](https://github.com/docker-library/official-images) (and [docs](https://github.com/docker-library/docs) if appropriate).

**Note: Java 9 support is experimental**

---
![Travis Build Status](https://travis-ci.org/groovy/docker-groovy.svg?branch=master)
