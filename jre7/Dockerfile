FROM openjdk:7-jre

CMD ["groovysh"]

ENV GROOVY_HOME /opt/groovy
ENV GROOVY_VERSION 2.4.9

RUN set -o errexit -o nounset \
	&& echo "Downloading Groovy" \
	&& wget --no-verbose --output-document=groovy.zip "https://dist.apache.org/repos/dist/release/groovy/${GROOVY_VERSION}/distribution/apache-groovy-binary-${GROOVY_VERSION}.zip" \
	\
	&& echo "Checking download signature" \
	&& wget --no-verbose --output-document=groovy.zip.asc "https://dist.apache.org/repos/dist/release/groovy/${GROOVY_VERSION}/distribution/apache-groovy-binary-${GROOVY_VERSION}.zip.asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& echo "Importing keys listed in http://www.apache.org/dist/groovy/KEYS from key server" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "0x41321490758AAD6F" "0x825C06C827AF6B66" "0x6A65176A0FB1CD0B" \
	&& gpg --batch --verify groovy.zip.asc groovy.zip \
	&& rm --recursive "${GNUPGHOME}" \
	&& rm groovy.zip.asc \
	\
	&& echo "Installing Groovy" \
	&& unzip groovy.zip \
	&& rm groovy.zip \
	&& mv "groovy-${GROOVY_VERSION}" "${GROOVY_HOME}" \
	&& ln --symbolic "${GROOVY_HOME}/bin/grape" /usr/bin/grape \
	&& ln --symbolic "${GROOVY_HOME}/bin/groovy" /usr/bin/groovy \
	&& ln --symbolic "${GROOVY_HOME}/bin/groovyc" /usr/bin/groovyc \
	&& ln --symbolic "${GROOVY_HOME}/bin/groovyConsole" /usr/bin/groovyConsole \
	&& ln --symbolic "${GROOVY_HOME}/bin/groovydoc" /usr/bin/groovydoc \
	&& ln --symbolic "${GROOVY_HOME}/bin/groovysh" /usr/bin/groovysh \
	&& ln --symbolic "${GROOVY_HOME}/bin/java2groovy" /usr/bin/java2groovy \
	\
	&& echo "Adding groovy user and group" \
	&& groupadd --system --gid 1000 groovy \
	&& useradd --system --gid groovy --uid 1000 --shell /bin/bash --create-home groovy \
	&& mkdir --parents /home/groovy/.groovy/grapes \
	&& chown --recursive groovy:groovy /home/groovy

USER groovy
VOLUME "/home/groovy/.groovy/grapes"
WORKDIR /home/groovy

RUN groovy --version
