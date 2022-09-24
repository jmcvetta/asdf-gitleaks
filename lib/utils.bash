#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/zricethezav/gitleaks"
TOOL_NAME="gitleaks"
TOOL_TEST="gitleaks --help"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if gitleaks is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  # Change this function if gitleaks has other means of determining installable versions.
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  local os arch
  case "$OSTYPE" in
  darwin*) os="darwin" ;;
  linux*) os="linux" ;;
  *) exit 1 ;;
  esac
  case $(uname -m) in
  x86_64) arch="x64" ;;
  arm*) arch="arm64" ;;
  esac

  # https://github.com/zricethezav/gitleaks/releases/download/v8.13.0/gitleaks_8.13.0_linux_x64.tar.gz
  url="$GH_REPO/releases/download/v${version}/gitleaks_${version}_${os}_${arch}.tar.gz"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"

  # FIXME: remove this DEBUG output
  echo
  echo "url=$url"
  echo
  echo "filename=$filename"
  echo
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi


  # FIXME: Remove this DEBUG output
  echo
  echo "ASDF_DOWNLOAD_PATH=$ASDF_DOWNLOAD_PATH"
  echo
  echo ls -l ASDF_DOWNLOAD_PATH
  ls -l $ASDF_DOWNLOAD_PATH
  echo


  (
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"


    # FIXME: Remove this DEBUG output
    echo
    echo "install_path=$install_path"
    echo
    echo ls -l install_path
    ls -l $install_path
    echo


    # TODO: Assert gitleaks executable exists.
    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error occurred while installing $TOOL_NAME $version."
  )
}
