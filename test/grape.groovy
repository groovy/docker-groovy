@Grapes([
    @Grab(group='org.apache.commons', module='commons-lang3', version='3.13.0')
])

import org.apache.commons.lang3.*

File getGroovyRoot() {
    String root = System.getProperty('groovy.root')
    def groovyRoot
    if (root == null) {
        groovyRoot = new File(System.getProperty('user.home'), '.groovy')
    } else {
        groovyRoot = new File(root)
    }
    try {
        groovyRoot = groovyRoot.getCanonicalFile()
    } catch (IOException ignore) {
        // skip canonicalization then, it may not exist yet
    }
    groovyRoot
}

File getGrapeDir() {
    String root = System.getProperty('grape.root')
    if (root == null) {
        return getGroovyRoot()
    }
    File grapeRoot = new File(root)
    try {
        grapeRoot = grapeRoot.getCanonicalFile()
    } catch (IOException ignore) {
        // skip canonicalization then, it may not exist yet
    }
    grapeRoot
}

File getGrapeCacheDir() {
    File cache = new File(getGrapeDir(), 'grapes')
    if (!cache.exists()) {
        cache.mkdirs()
    } else if (!cache.isDirectory()) {
        throw new RuntimeException("The grape cache dir $cache is not a directory")
    }
    cache
}

if (getGrapeCacheDir().listFiles().size() == 0) {
    throw new RuntimeException('No Grapes files')
}
