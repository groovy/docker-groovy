FROM openjdk:9-jdk

CMD ["groovysh"]

WORKDIR /opt
ENV GROOVY_HOME /opt/groovy
ENV PATH "${GROOVY_HOME}/bin:${PATH}"

ENV GROOVY_VERSION 2.4.9
RUN set -o errexit -o nounset \
	&& echo "Downloading Groovy" \
	&& wget --no-verbose --output-document=groovy.zip "https://dist.apache.org/repos/dist/release/groovy/${GROOVY_VERSION}/distribution/apache-groovy-binary-${GROOVY_VERSION}.zip" \
	\
	&& echo "Installing build dependencies" \
	&& apt-get update \
	&& apt-get update && apt-get install --yes --no-install-recommends \
		dirmngr \
		gnupg \
	&& rm --recursive /var/lib/apt/lists/* \
	\
	&& echo "Checking download signature" \
	&& wget --no-verbose --output-document=groovy.zip.asc "https://dist.apache.org/repos/dist/release/groovy/${GROOVY_VERSION}/distribution/apache-groovy-binary-${GROOVY_VERSION}.zip.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& echo "Importing keys listed in http://www.apache.org/dist/groovy/KEYS from key server" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "0x41321490758AAD6F" "0x825C06C827AF6B66" "0x6A65176A0FB1CD0B" \
	&& gpg --batch --verify groovy.zip.asc groovy.zip \
	&& rm --recursive --force "${GNUPGHOME}" \
	&& rm groovy.zip.asc \
	\
	&& echo "Installing Groovy" \
	&& unzip groovy.zip \
	&& rm groovy.zip \
	&& mv "groovy-${GROOVY_VERSION}" "${GROOVY_HOME}" \
	\
	&& echo "Cleaning up build dependencies" \
	&& echo $(apt-mark showauto) \
	&& apt-get remove --yes --purge \
		dirmngr \
		gnupg \
	&& apt-get autoremove --yes --purge \
	\
	&& groovy --version
