FROM openjdk:8u111-jdk

ENV GROOVY_VERSION 2.4.8
ARG GROOVY_DOWNLOAD_SHA256=668a65ea17037371a1952cca5f42ebc03329e15d3619aacb4c7dd5f4b39a8dfd

ENV GROOVY_HOME /opt/groovy
ENV PATH ${GROOVY_HOME}/bin:$PATH

WORKDIR /opt
RUN set -ex \
	&& echo "Downloading Groovy" \
	&& wget -nv "http://dl.bintray.com/groovy/maven/apache-groovy-binary-${GROOVY_VERSION}.zip" \
	&& echo "$GROOVY_DOWNLOAD_SHA256 *apache-groovy-binary-${GROOVY_VERSION}.zip" | sha256sum -c - \
	\
	&& echo "Installing Groovy" \
	&& unzip apache-groovy-binary-${GROOVY_VERSION}.zip \
	&& rm apache-groovy-binary-${GROOVY_VERSION}.zip \
	&& mv "groovy-${GROOVY_VERSION}" /opt/groovy

CMD ["groovysh"]
