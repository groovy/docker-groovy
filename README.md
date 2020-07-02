# docker-groovy

## Supported tags and respective Dockerfile links

* [jdk8, jdk](https://github.com/groovy/docker-groovy/blob/master/jdk8/Dockerfile)
* [latest, jre8, jre](https://github.com/groovy/docker-groovy/blob/master/jre8/Dockerfile)

* [jdk11](https://github.com/groovy/docker-groovy/blob/master/jdk11/Dockerfile)
* [jre11](https://github.com/groovy/docker-groovy/blob/master/jre11/Dockerfile)

* [jdk14](https://github.com/groovy/docker-groovy/blob/master/jdk14/Dockerfile)
* [jre14](https://github.com/groovy/docker-groovy/blob/master/jre14/Dockerfile)

## What is Groovy?

[Apache Groovy](http://groovy-lang.org/) is a powerful, optionally typed and dynamic language, with static-typing and static compilation capabilities, for the Java platform aimed at improving developer productivity thanks to a concise, familiar and easy to learn syntax. It integrates smoothly with any Java program, and immediately delivers to your application powerful features, including scripting capabilities, Domain-Specific Language authoring, runtime and compile-time meta-programming and functional programming.

## How to use this image

Note that if you are mounting a volume and the uid running Docker is not _1000_, you should run as user _root_ (`-u root`).

### Starting Groovysh

`docker run -it --rm groovy:latest`

### Running a Groovy script

#### Bash/Zsh

`docker run --rm -v "$PWD":/home/groovy/scripts -w /home/groovy/scripts groovy:latest groovy <script> <script-args>`

#### PowerShell

`docker run --rm -v "${pwd}:/home/groovy/scripts" -w /home/groovy/scripts groovy:latest groovy <script> <script-args>`

#### Windows CMD

`docker run --rm -v "%cd%:/home/groovy/scripts" -w /home/groovy/scripts groovy:latest groovy <script> <script-args>`

### Reusing the Grapes cache

The local Grapes cache can be reused across containers by creating a volume and mounting it in */home/groovy/.groovy/grapes*.

```
docker volume create --name grapes-cache
docker run --rm -it -v grapes-cache:/home/groovy/.groovy/grapes groovy:latest
```

## Instructions for a new Groovy release

1. Run `update.sh <new Groovy version>` or `update.ps1 <new Groovy version>`.
1. If a Groovy contributor did a release for the first time (his/her key added to https://downloads.apache.org/groovy/KEYS),
add the new key to the list of keys used for verification (this is quite infrequent).
1. Commit and push the changes.
1. Update [official-images](https://github.com/docker-library/official-images) (and [docs](https://github.com/docker-library/docs) if appropriate).

---
![Travis Build Status](https://travis-ci.org/groovy/docker-groovy.svg?branch=master)
