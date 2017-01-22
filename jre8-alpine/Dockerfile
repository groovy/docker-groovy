FROM openjdk:8u111-jre-alpine

ENV GROOVY_VERSION 2.4.8
ARG GROOVY_DOWNLOAD_SHA256=668a65ea17037371a1952cca5f42ebc03329e15d3619aacb4c7dd5f4b39a8dfd

ENV GROOVY_HOME /opt/groovy
ENV PATH ${GROOVY_HOME}/bin:$PATH

RUN set -ex \
	&& apk add --no-cache \
		bash=4.3.42-r4 \
		unzip

WORKDIR /opt
RUN set -ex \
	&& echo "Downloading Groovy" \
	&& wget "http://dl.bintray.com/groovy/maven/apache-groovy-binary-${GROOVY_VERSION}.zip" \
	&& echo "$GROOVY_DOWNLOAD_SHA256 *apache-groovy-binary-${GROOVY_VERSION}.zip" | sha256sum -c - \
	\
	&& echo "Installing Groovy" \
	&& unzip apache-groovy-binary-${GROOVY_VERSION}.zip \
	&& apk del unzip \
	&& rm apache-groovy-binary-${GROOVY_VERSION}.zip \
	&& mv "groovy-${GROOVY_VERSION}" /opt/groovy \
	\
	&& echo "Applying workaround for GROOVY-7906" \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/grape \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/groovy \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/groovyc \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/groovyConsole \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/groovydoc \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/groovysh \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/java2groovy

CMD ["groovysh"]
