#!/usr/bin/env bash
set -euo pipefail

script_dir=${BASH_SOURCE[0]%/*}
source "$script_dir/../version-utils.sh"

assert_equal() {
    expected=$1
    actual=$2
    if [[ "$expected" != "$actual" ]]; then
        printf 'Expected %s, got %s\n' "$expected" "$actual" >&2
        exit 1
    fi
}

assert_success() {
    if ! "$@"; then
        printf 'Expected command to succeed: %s\n' "$*" >&2
        exit 1
    fi
}

assert_failure() {
    if "$@"; then
        printf 'Expected command to fail: %s\n' "$*" >&2
        exit 1
    fi
}

assert_equal '4.0.0-alpha-1' "$(normalize_groovy_version GROOVY_4_0_0_ALPHA_1)"
assert_equal '4.0.0-beta-2' "$(normalize_groovy_version GROOVY_4_0_0_BETA_2)"
assert_equal '4.0.0-rc-3' "$(normalize_groovy_version GROOVY_4_0_0_RC_3)"
assert_equal '4.0.0' "$(normalize_groovy_version GROOVY_4_0_0)"
assert_success is_groovy_prerelease 4.0.0-alpha-1
assert_success is_groovy_prerelease 4.0.0-beta-2
assert_success is_groovy_prerelease 4.0.0-rc-3
assert_failure is_groovy_prerelease 4.0.0
assert_failure is_groovy_prerelease x4.0.0-alpha-1

assert_tag_versions() {
    local version=$1
    shift
    local expected=("$@")
    local actual=()
    mapfile -t actual < <(groovy_tag_versions "$version")
    assert_equal "${#expected[@]}" "${#actual[@]}"
    local index
    for index in "${!expected[@]}"; do
        assert_equal "${expected[index]}" "${actual[index]}"
    done
}

assert_tag_versions 6.0.0-beta-2 6.0.0-beta-2 6.0 6
assert_tag_versions 5.1.0 5.1.0 5.1 5 ''

printf 'version-utils.sh tests passed\n'
