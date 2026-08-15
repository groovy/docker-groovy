normalize_groovy_version() {
    local version=${1#GROOVY_}
    version=${version//_/.}
    version=${version//.ALPHA./-alpha-}
    version=${version//.BETA./-beta-}
    version=${version//.RC./-rc-}
    printf '%s\n' "$version"
}

is_groovy_prerelease() {
    [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+-(alpha|beta|rc)-[0-9]+$ ]]
}

groovy_tag_versions() {
    local version=$1
    if is_groovy_prerelease "$version"; then
        printf '%s\n' "$version" "${version%.*}" "${version%.*.*}"
        return
    fi
    printf '%s\n' "$version" "${version%.*}" "${version%.*.*}" ''
}
