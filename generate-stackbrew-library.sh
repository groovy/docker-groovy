#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail

# NOTE: run something like `git fetch origin` before this script to ensure all remote branch references are up-to-date!

# usage: ./generate-stackbrew-library.sh > ../official-images/library/groovy

# front-load the "command-not-found" notices
jq --version > /dev/null
bashbrew --version > /dev/null

cat <<-'EOH'
	Maintainers: Keegan Witt <keeganwitt@gmail.com> (@keeganwitt)
	GitRepo: https://github.com/groovy/docker-groovy.git
EOH

declare -A usedTags=() archesLookupCache=() seenVersions=()
commit="$(git rev-parse HEAD)"
branch="$(git rev-parse --abbrev-ref HEAD)"
common="$(
	cat <<-EOC
		GitFetch: refs/heads/$branch
	EOC
)"

directories="$(
	git ls-tree -r --name-only "$commit" | jq --raw-input --null-input --raw-output '
		# convert "git ls-tree" output to a list of directories that contain a Dockerfile
		[
			inputs
			| select(endswith("/Dockerfile"))
			| rtrimstr("/Dockerfile")
		]
		| sort_by(
			# sort the list:
			# - Groovy version in descending order
			# - LTS JDK versions in descending order
			# - non-LTS JDK versions in descending order
			# - plain (temurin) variants above alpine
			# - Ubuntu versions in descending release order
			# (presorting the list makes tag calculation easier later because we can simply generate a list of tags each combination *could* have and let the first one to try get it, being careful not to reuse any)
			(
				split("/")[0]
				| split("-")[1]
				| tonumber
			) as $groovy
			| (
				split("/")[1]
				| ltrimstr("jdk")
				| split("-")[0]
				| tonumber
			) as $jdk
			| [
				(-$groovy),
				# LTS JDK versions above non-LTS
				(
					if $jdk | IN(21, 17, 11, 8) then 0
					else 1 end
				),
				# JDK versions in descending version order
				(
					-$jdk # negative so they sort in reverse order
				),
				# plain vs alpine
				(
					if contains("alpine") then 1
					else 0 end
				),
				# ubuntu versions in descending order
				(
					# if unspecified, we assume "latest" (currently "noble")
					if contains("jammy") then -1
					else -2 end
				),
				. # if all else fails, sort lexicographically
			]
		)
		# escape for passing to the shell (safely)
		| map(@sh)
		| join(" ")
	'
)"
eval "directories=( $directories )"


for dir in "${directories[@]}"; do
	# shellcheck disable=SC2001
	dir="$(echo "$dir" | sed -e 's/[[:space:]]*$//')"
	if [ ! -d "$dir" ]; then
		# skip directory that doesn't exist in this branch
		continue
	fi

	dockerfile="$(git show "$commit:$dir/Dockerfile")"

	# extract "FROM" and "GROOVY_VERSION" from Dockerfile
	from="$(awk <<<"$dockerfile" 'toupper($1) == "FROM" { print $2; exit }')"
	version="$(awk <<<"$dockerfile" -F '[=[:space:]]+' 'toupper($1) == "ENV" && $2 == "GROOVY_VERSION" { print $3; exit }')"
	# add a patch version of 0 if missing
	if [[ "$version" =~ ^[0-9]+\.[0-9]+$ ]]; then
		version="${version}.0"
	fi

	majorVersion="${version%%.*}"
	
	# double-check that each version matches the first one for this major (they should all be updated in lock-step)
	# declare -A firstVersions is not available in older bash, using variable indirection or assume bash 4+ (which is checked via declare -A usedTags)
	: "${seenVersions[$majorVersion]:=$version}"
	if [ "$version" != "${seenVersions[$majorVersion]}" ]; then
		echo >&2 "error: $dir contains $version (compared to ${seenVersions[$majorVersion]} in other images of major version $majorVersion)"
		exit 1
	fi

	# Get the git commit for the specific directory
	majorDir="${dir%%/*}"
	commit="$(git log -1 --format='%H' -- "$majorDir")"

	fromTag="${from##*:}"
	suite="${fromTag%-jdk}"
	suite="${suite##*-}" # "noble", "jammy", etc
	dirName="${dir##*/}"
	jdk="${dirName%%-*}" # "jdk8", etc

	# identify image "variant" so we can assign tags based on variant
	case "$dir" in
		*-alpine)   variant='alpine' ;;
		*)          variant='' ;;
	esac

	# build up a list of tags we want to assign this directory, then filter out ones we've already used (a major benefit of our priority sorting above)
	tags=()
	versions=(
		# this assumes upstream's version numbers always have three parts - if that ever changes, this needs to become more complex
		"$version"        # X.Y.Z
		"${version%.*}"   # X.Y
		"${version%.*.*}" # X
		''                # this will lead to some tags that start with hyphen; we'll clean them up afterwards (it makes the logic easier to write correctly so we get all of "X.Y.Z-foo", "X.Y-foo", "X-foo", *and* "foo")
	)
	tags+=( "${versions[@]/%/-$jdk${variant:+-$variant}}" ) # "X.Y.Z-jdkNN-alpine"
	case "$variant" in
		'')
			tags+=( "${versions[@]/%/-$jdk-$suite}" ) # "X.Y.Z-jdkNN-noble"

			# Only add "latest" tag for Groovy 5
			if [[ "$version" == 5.* ]]; then
				tags+=( 'latest' )
			fi

			tags+=(
				"${versions[@]/%/-jdk}" # "X.Y.Z-jdk"
				"${versions[@]}" # "X.Y.Z"
				"${versions[@]/%/-jdk-$suite}" # "X.Y.Z-jdk-noble"
				"${versions[@]/%/-$suite}" # "X.Y.Z-noble"
			)
			;;
		alpine)
			tags+=(
				"${versions[@]/%/-jdk-alpine}" # "X.Y.Z-jdk-alpine"
				"${versions[@]/%/-alpine}" # "X.Y.Z-alpine"
			)
			if [[ "$version" == 5.* ]]; then
				tags+=( 'alpine' )
			fi
			;;
	esac

	actualTags=
	for tag in "${tags[@]}"; do
		tag="${tag#-}" # remove those errant hyphen prefixes mentioned above
		if [ -z "$tag" ] || [ -n "${usedTags[$tag]:-}" ]; then
			continue
		fi
		usedTags[$tag]=1
		actualTags="${actualTags:+$actualTags, }$tag"
	done

	# cache values to avoid excessive lookups for repeated base images
	arches="${archesLookupCache[$from]:-}"
	if [ -z "$arches" ]; then
		arches="$(bashbrew cat --format '{{ join ", " .TagEntry.Architectures }}' "https://github.com/docker-library/official-images/raw/HEAD/library/$from")"
		archesLookupCache[$from]="$arches"
	fi

	cat <<-EOE

		Tags: $actualTags
		Architectures: $arches
		$common
		GitCommit: $commit
		Directory: $dir
	EOE
done
