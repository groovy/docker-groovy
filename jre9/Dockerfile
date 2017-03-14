FROM openjdk:9-jre

CMD ["groovysh"]

ENV GROOVY_HOME /opt/groovy
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
	&& echo "Importing keys listed in http://www.apache.org/dist/groovy/KEYS from key server" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& for key in \
		"0x41321490758AAD6F" \
		"0x825C06C827AF6B66" \
		"0x6A65176A0FB1CD0B" \
	; do \
		for server in \
			ha.pool.sks-keyservers.net \
			hkp://p80.pool.sks-keyservers.net:80 \
			pgp.mit.edu \
		; do \
			echo "  Trying ${server}"; \
			if gpg --keyserver "${server}" --recv-keys "${key}"; then \
				break; \
			fi; \
		done; \
	done; \
	if [ $(gpg --list-keys | grep -c "pub ") -ne 3 ]; then \
		echo "ERROR: Failed to fetch GPG keys" >&2; \
		exit 1; \
	fi \
	\
	&& echo "Checking download signature" \
	&& wget --no-verbose --output-document=groovy.zip.asc "https://dist.apache.org/repos/dist/release/groovy/${GROOVY_VERSION}/distribution/apache-groovy-binary-${GROOVY_VERSION}.zip.asc" \
	&& gpg --batch --verify groovy.zip.asc groovy.zip \
	&& rm --recursive --force "${GNUPGHOME}" \
	&& rm groovy.zip.asc \
	\
	&& echo "Installing Groovy" \
	&& unzip groovy.zip \
	&& rm groovy.zip \
	&& mv "groovy-${GROOVY_VERSION}" "${GROOVY_HOME}/" \
	&& ln --symbolic "${GROOVY_HOME}/bin/grape" /usr/bin/grape \
	&& ln --symbolic "${GROOVY_HOME}/bin/groovy" /usr/bin/groovy \
	&& ln --symbolic "${GROOVY_HOME}/bin/groovyc" /usr/bin/groovyc \
	&& ln --symbolic "${GROOVY_HOME}/bin/groovyConsole" /usr/bin/groovyConsole \
	&& ln --symbolic "${GROOVY_HOME}/bin/groovydoc" /usr/bin/groovydoc \
	&& ln --symbolic "${GROOVY_HOME}/bin/groovysh" /usr/bin/groovysh \
	&& ln --symbolic "${GROOVY_HOME}/bin/java2groovy" /usr/bin/java2groovy \
	\
	&& echo "Cleaning up build dependencies" \
	&& echo $(apt-mark showauto) \
	&& apt-get remove --yes --purge \
		dirmngr \
		gnupg \
	&& apt-get autoremove --yes --purge \
	\
	&& echo "Adding groovy user and group" \
	&& groupadd --system --gid 1000 groovy \
	&& useradd --system --gid groovy --uid 1000 --shell /bin/bash --create-home groovy \
	&& mkdir --parents /home/groovy/.groovy/grapes \
	&& chown --recursive groovy:groovy /home/groovy \
	\
	&& echo "Applying workaround for https://github.com/docker-library/openjdk/issues/101" \
	&& bash -c '([[ ! -d $JAVA_SECURITY_DIR ]] && ln -s $JAVA_HOME/lib $JAVA_HOME/conf) || (echo "Found java conf dir, package has been fixed, remove this hack"; exit -1)'

# Create Grapes volume
USER groovy
VOLUME "/home/groovy/.groovy/grapes"
WORKDIR /home/groovy

RUN set -o errexit -o nounset \
	&& echo "Testing Groovy installation" \
	&& groovy --version
