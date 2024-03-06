#!/bin/bash
set -euo pipefail

script_folder=$(dirname "${BASH_SOURCE[0]}")
source "${script_folder}"/funcs.sh

# Get the latest Git tag.
latest_tag=$(get_latest_tag)
if [[ -z ${latest_tag} ]]; then
	echo "No tags found. Please create first tag manually to enable auto-tagging."
	exit 1
fi
echo "Latest tag: ${latest_tag}"

pr_body="$1"

# Get selected versioning checkboxes.
is_patch=$(is_patch_selected "${pr_body}")
is_minor=$(is_minor_selected "${pr_body}")
is_major=$(is_major_selected "${pr_body}")

pr_number="$2"

if { [[ ${is_minor} == true ]] && [[ ${is_patch} == true ]]; } ||
	{ [[ ${is_minor} == true ]] && [[ ${is_major} == true ]]; } ||
	{ [[ ${is_patch} == true ]] && [[ ${is_major} == true ]]; }; then
	echo "Ambiguous tag information in body of pull request #${pr_number}. Auto-tagging will use most senior version option selected."
fi

# Extract the version numbers from the tag
version_numbers=${latest_tag#v}       # Remove the leading 'v'
version_numbers=${version_numbers%-*} # Remove the trailing '-beta'
major_version=$(get_major "${version_numbers}")
minor_version=$(get_minor "${version_numbers}")
patch_version=$(get_patch "${version_numbers}")
maturity=$(get_maturity "${latest_tag}")
if [[ -n ${maturity} ]]; then
	maturity="-${maturity}"
fi

# Auto-tag based on most senior version selected.
if [[ ${is_major} == true ]]; then
	new_major_version=$(increment "${major_version}")
	new_tag=v${new_major_version}.0.0${maturity}
	echo "Tagging as new major version ${new_tag}..."
elif [[ ${is_minor} == true ]]; then
	new_minor_version=$(increment "${minor_version}")
	new_tag="v${major_version}.${new_minor_version}.0${maturity}"
	echo "Tagging as new minor version ${new_tag}..."
else
	new_patch_version=$(increment "${patch_version}")
	new_tag=v${major_version}.${minor_version}.${new_patch_version}${maturity}
	echo "Tagging as new patch ${new_tag}..."
fi

# If multiple have been checked or none have been checked, don't auto tag.
if { [[ ${is_minor} == false ]] && [[ ${is_patch} == false ]] && [[ ${is_major} == false ]]; }; then
	echo "No tag information found in body of pull request #${pr_number}. Auto-tagging failed..."
	exit 1
fi

echo "${new_tag}"
