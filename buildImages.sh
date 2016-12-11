groovyVersion=2.4.7

cd openjdk-jre7
docker build -t groovy:openjdk-jre7-${groovyVersion} -t groovy:openjdk-jre7-latest .
cd openjdk-jdk7
docker build -t groovy:openjdk-jdk7-${groovyVersion} -t groovy:openjdk-jdk7-latest .
# commented out until https://issues.apache.org/jira/browse/GROOVY-7906 is resolved
#cd openjdk-jre7-alpine
#docker build -t groovy:openjdk-jre7-${groovyVersion}-alpine -t groovy:openjdk-jre7-latest-alpine .
#cd openjdk-jdk7-alpine
#docker build -t groovy:openjdk-jdk7-${groovyVersion}-alpine -t groovy:openjdk-jdk7-latest-alpine .

cd openjdk-jre8
docker build -t groovy:openjdk-jre8-${groovyVersion} -t groovy:openjdk-jre8-latest .
cd openjdk-jdk8
docker build -t groovy:openjdk-jdk8-${groovyVersion} -t groovy:openjdk-jdk8-latest .
# commented out until https://issues.apache.org/jira/browse/GROOVY-7906 is resolved
#cd openjdk-jre8-alpine
#docker build -t groovy:openjdk-jre8-${groovyVersion}-alpine -t groovy:openjdk-jre8-latest-alpine .
#cd openjdk-jdk8-alpine
#docker build -t groovy:openjdk-jdk8-${groovyVersion}-alpine -t groovy:openjdk-jdk8-latest-alpine .
