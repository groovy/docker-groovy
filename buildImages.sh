groovyVersion=2.4.7

cd jre7
docker build -t groovy:jre7-${groovyVersion} -t groovy:jre7-latest .
cd jdk7
docker build -t groovy:jdk7-${groovyVersion} -t groovy:jdk7-latest .
cd jre7-alpine
docker build -t groovy:jre7-${groovyVersion}-alpine -t groovy:jre7-latest-alpine .
cd jdk7-alpine
docker build -t groovy:jdk7-${groovyVersion}-alpine -t groovy:jdk7-latest-alpine .

cd jre8
docker build -t groovy:jre8-${groovyVersion} -t groovy:jre8-latest .
cd jdk8
docker build -t groovy:jdk8-${groovyVersion} -t groovy:jdk8-latest .
cd jre8-alpine
docker build -t groovy:jre8-${groovyVersion}-alpine -t groovy:jre8-latest-alpine .
cd jdk8-alpine
docker build -t groovy:jdk8-${groovyVersion}-alpine -t groovy:jdk8-latest-alpine .
