FROM openjdk:7-jdk-alpine

ENV PATH /opt/groovy/bin:$PATH

ENV GROOVY_VERSION 2.4.7
ENV GROOVY_DOWNLOAD_SHA256 438dd6098252647e88ff12ac5737d0d0f7e16a8e4e42e8be3e05a4c43abefbd5

RUN set -ex \
	&& apk add --update bash ca-certificates openssl unzip \
	&& rm -rf /var/cache/apk/*

WORKDIR /opt
RUN set -ex \
	&& wget "https://dl.bintray.com/groovy/maven/apache-groovy-binary-${GROOVY_VERSION}.zip" \
	&& echo "$GROOVY_DOWNLOAD_SHA256 *apache-groovy-binary-${GROOVY_VERSION}.zip" | sha256sum -c - \
	\
	&& unzip apache-groovy-binary-${GROOVY_VERSION}.zip \
	&& rm apache-groovy-binary-${GROOVY_VERSION}.zip \
	&& mv "groovy-${GROOVY_VERSION}" /opt/groovy \
	\
	&& sed -i -e "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/grape \
	&& sed -i -e "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/groovy \
	&& sed -i -e "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/groovyc \
	&& sed -i -e "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/groovyConsole \
	&& sed -i -e "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/groovydoc \
	&& sed -i -e "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/groovysh \
	&& sed -i -e "s|#!/bin/sh|#!/bin/bash|" /opt/groovy/bin/java2groovy \
	\
	&& groovy --version

CMD ["groovysh"]
