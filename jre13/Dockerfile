FROM adoptopenjdk:13-jre-hotspot

CMD ["groovysh"]

ENV GROOVY_HOME /opt/groovy

RUN set -o errexit -o nounset \
    && echo "Adding groovy user and group" \
    && groupadd --system --gid 1000 groovy \
    && useradd --system --gid groovy --uid 1000 --shell /bin/bash --create-home groovy \
    && mkdir --parents /home/groovy/.groovy/grapes \
    && chown --recursive groovy:groovy /home/groovy \
    \
    && echo "Symlinking root .groovy to groovy .groovy" \
    && ln --symbolic /home/groovy/.groovy /root/.groovy

VOLUME /home/groovy/.groovy/grapes

WORKDIR /home/groovy

RUN apt-get update \
    && echo "Installing build dependencies" \
    && apt-get install --yes --no-install-recommends \
        dirmngr \
        fontconfig \
        gnupg \
        unzip \
        wget \
    && rm --recursive --force /var/lib/apt/lists/*

ENV GROOVY_VERSION 3.0.0-rc-1
RUN set -o errexit -o nounset \
    && echo "Downloading Groovy" \
    && wget --no-verbose --output-document=groovy.zip "https://dist.apache.org/repos/dist/release/groovy/${GROOVY_VERSION}/distribution/apache-groovy-binary-${GROOVY_VERSION}.zip" \
    \
    && echo "Importing keys listed in http://www.apache.org/dist/groovy/KEYS from key server" \
    && export GNUPGHOME="$(mktemp -d)"; \
    for key in \
        "7FAA0F2206DE228F0DB01AD741321490758AAD6F" \
        "331224E1D7BE883D16E8A685825C06C827AF6B66" \
        "34441E504A937F43EB0DAEF96A65176A0FB1CD0B" \
        "9A810E3B766E089FFB27C70F11B595CEDC4AEBB5" \
        "81CABC23EECA0790E8989B361FF96E10F0E13706" \
    ; do \
        for server in \
            "ha.pool.sks-keyservers.net" \
            "hkp://p80.pool.sks-keyservers.net:80" \
            "pgp.mit.edu" \
        ; do \
            echo "  Trying ${server}"; \
            if gpg --batch --no-tty --keyserver "${server}" --recv-keys "${key}"; then \
                break; \
            fi; \
        done; \
    done; \
    if [ $(gpg --batch --no-tty --list-keys | grep --count "pub ") -ne 5 ]; then \
        echo "ERROR: Failed to fetch GPG keys" >&2; \
        exit 1; \
    fi \
    \
    && echo "Checking download signature" \
    && wget --no-verbose --output-document=groovy.zip.asc "https://dist.apache.org/repos/dist/release/groovy/${GROOVY_VERSION}/distribution/apache-groovy-binary-${GROOVY_VERSION}.zip.asc" \
    && gpg --batch --no-tty --verify groovy.zip.asc groovy.zip \
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
    && echo "Editing startGroovy to include java.xml.bind module" \
    && sed --in-place 's|startGroovy ( ) {|startGroovy ( ) {\n    JAVA_OPTS="$JAVA_OPTS --add-modules=ALL-SYSTEM"|' "${GROOVY_HOME}/bin/startGroovy"

USER groovy

RUN set -o errexit -o nounset \
    && echo "Testing Groovy installation" \
    && groovy --version
