FROM openjdk:7-jdk-alpine

CMD ["groovysh"]

WORKDIR /opt
ENV GROOVY_HOME /opt/groovy
ENV PATH "${GROOVY_HOME}/bin:${PATH}"

ENV GROOVY_VERSION 2.4.9
RUN set -o errexit -o nounset \
	&& echo "Installing dependencies" \
	&& apk add --no-cache \
		bash \
	\
	&& echo "Installing build dependencies" \
	&& apk add --no-cache --virtual .build-deps \
		ca-certificates \
		gnupg \
		openssl \
		unzip \
	\
	&& echo "Downloading Groovy" \
	&& wget -O groovy.zip "https://dist.apache.org/repos/dist/release/groovy/${GROOVY_VERSION}/distribution/apache-groovy-binary-${GROOVY_VERSION}.zip" \
	\
	&& echo "Checking download signature" \
	&& wget -O groovy.zip.asc "https://dist.apache.org/repos/dist/release/groovy/${GROOVY_VERSION}/distribution/apache-groovy-binary-${GROOVY_VERSION}.zip.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& echo "Importing keys listed in http://www.apache.org/dist/groovy/KEYS from key server" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "0x41321490758AAD6F" "0x825C06C827AF6B66" "0x6A65176A0FB1CD0B" \
	&& gpg --batch --verify groovy.zip.asc groovy.zip \
	&& rm -r "${GNUPGHOME}" \
	&& rm groovy.zip.asc \
	\
	&& echo "Installing Groovy" \
	&& unzip groovy.zip \
	&& rm groovy.zip \
	&& mv "groovy-${GROOVY_VERSION}" "${GROOVY_HOME}" \
	\
	&& echo "Applying workaround for https://issues.apache.org/jira/browse/GROOVY-7906" \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" "${GROOVY_HOME}/bin/grape" \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" "${GROOVY_HOME}/bin/groovy" \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" "${GROOVY_HOME}/bin/groovyc" \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" "${GROOVY_HOME}/bin/groovyConsole" \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" "${GROOVY_HOME}/bin/groovydoc" \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" "${GROOVY_HOME}/bin/groovysh" \
	&& sed -i "s|#!/bin/sh|#!/bin/bash|" "${GROOVY_HOME}/bin/java2groovy" \
	\
	&& echo "Cleaning up build dependencies" \
	&& apk del .build-deps \
	\
	&& groovy --version
