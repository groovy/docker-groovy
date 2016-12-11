FROM openjdk:7-jre

ENV PATH /opt/groovy/bin:$PATH

ENV GROOVY_VERSION 2.4.7
ENV GROOVY_DOWNLOAD_SHA256 438dd6098252647e88ff12ac5737d0d0f7e16a8e4e42e8be3e05a4c43abefbd5

WORKDIR /opt
RUN set -ex \
	&& wget "http://dl.bintray.com/groovy/maven/apache-groovy-binary-${GROOVY_VERSION}.zip" \
	&& echo "$GROOVY_DOWNLOAD_SHA256 *apache-groovy-binary-${GROOVY_VERSION}.zip" | sha256sum -c - \
	\
	&& unzip apache-groovy-binary-${GROOVY_VERSION}.zip \
	&& rm apache-groovy-binary-${GROOVY_VERSION}.zip \
	&& mv "groovy-${GROOVY_VERSION}" /opt/groovy \
	\
	&& groovy --version

CMD ["groovysh"]
