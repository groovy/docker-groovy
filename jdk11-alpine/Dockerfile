FROM eclipse-temurin:11-jdk-alpine

CMD ["groovysh"]

ENV GROOVY_HOME=/opt/groovy

RUN set -o errexit -o nounset \
    && echo "Adding groovy user and group" \
    && addgroup --system --gid 1000 groovy \
    && adduser --system --ingroup groovy --uid 1000 --shell /bin/ash groovy \
    && mkdir --parents /home/groovy/.groovy/grapes \
    && chown -R groovy:groovy /home/groovy \
    && chmod -R 1777 /home/groovy \
    \
    && echo "Symlinking root .groovy to groovy .groovy" \
    && ln -s /home/groovy/.groovy /root/.groovy

VOLUME /home/groovy/.groovy/grapes

WORKDIR /home/groovy

ENV GROOVY_VERSION=4.0.27
RUN set -o errexit -o nounset \
    && echo "Installing build dependencies" \
    && apk add --no-cache --virtual .build-deps \
        gnupg \
    \
    && echo "Downloading Groovy" \
    && wget --no-verbose --output-document=groovy.zip "https://archive.apache.org/dist/groovy/${GROOVY_VERSION}/distribution/apache-groovy-binary-${GROOVY_VERSION}.zip" \
    \
    && echo "Importing keys listed in http://www.apache.org/dist/groovy/KEYS from key server" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --batch --no-tty --keyserver keyserver.ubuntu.com --recv-keys \
        7FAA0F2206DE228F0DB01AD741321490758AAD6F \
        331224E1D7BE883D16E8A685825C06C827AF6B66 \
        34441E504A937F43EB0DAEF96A65176A0FB1CD0B \
        9A810E3B766E089FFB27C70F11B595CEDC4AEBB5 \
        81CABC23EECA0790E8989B361FF96E10F0E13706 \
    \
    && echo "Checking download signature" \
    && wget --no-verbose --output-document=groovy.zip.asc "https://archive.apache.org/dist/groovy/${GROOVY_VERSION}/distribution/apache-groovy-binary-${GROOVY_VERSION}.zip.asc" \
    && gpg --batch --no-tty --verify groovy.zip.asc groovy.zip \
    && (rm -rf "${GNUPGHOME}" || true) \
    && rm groovy.zip.asc \
    \
    && echo "Cleaning up build dependencies" \
    && apk del .build-deps \
    \
    && echo "Installing Groovy" \
    && unzip groovy.zip \
    && rm groovy.zip \
    && mv "groovy-${GROOVY_VERSION}" "${GROOVY_HOME}/" \
    && rm -f "${GROOVY_HOME}/lib/groovy-raw-${GROOVY_VERSION}-raw.jar" \
    && ln -s "${GROOVY_HOME}/bin/grape" /usr/bin/grape \
    && ln -s "${GROOVY_HOME}/bin/groovy" /usr/bin/groovy \
    && ln -s "${GROOVY_HOME}/bin/groovyc" /usr/bin/groovyc \
    && ln -s "${GROOVY_HOME}/bin/groovyConsole" /usr/bin/groovyConsole \
    && ln -s "${GROOVY_HOME}/bin/groovydoc" /usr/bin/groovydoc \
    && ln -s "${GROOVY_HOME}/bin/groovysh" /usr/bin/groovysh \
    && ln -s "${GROOVY_HOME}/bin/java2groovy" /usr/bin/java2groovy \
    \
    && echo "Editing startGroovy to include java.xml.bind module" \
    && sed --in-place 's|startGroovy ( ) {|startGroovy ( ) {\n    JAVA_OPTS="$JAVA_OPTS --add-modules=ALL-SYSTEM"|' "${GROOVY_HOME}/bin/startGroovy"

USER 1000:1000

RUN set -o errexit -o nounset \
    && echo "Testing Groovy installation" \
    && groovy --version
