FROM openjdk:8-jdk-alpine

ENV GROOVY_VERSION 2.4.7
ENV GROOVY_DOWNLOAD_SHA256 438dd6098252647e88ff12ac5737d0d0f7e16a8e4e42e8be3e05a4c43abefbd5

ENV GROOVY_HOME /opt/groovy
ENV PATH ${GROOVY_HOME}/bin:$PATH

RUN set -ex \
	&& apk add --update bash unzip \
	&& rm -rf /var/cache/apk/*

RUN set -ex \
	&& wget "http://dl.bintray.com/groovy/maven/apache-groovy-binary-${GROOVY_VERSION}.zip" \
	&& echo "$GROOVY_DOWNLOAD_SHA256 *apache-groovy-binary-${GROOVY_VERSION}.zip" | sha256sum -c - \
	\
	&& unzip apache-groovy-binary-${GROOVY_VERSION}.zip \
	&& apk del unzip \
	&& rm apache-groovy-binary-${GROOVY_VERSION}.zip \
	&& mv "groovy-${GROOVY_VERSION}" /opt/groovy \
	\
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/grape \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/groovy \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/groovyc \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/groovyConsole \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/groovydoc \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/groovysh \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/java2groovy \
	\
	&& groovy --version

CMD ["groovysh"]
