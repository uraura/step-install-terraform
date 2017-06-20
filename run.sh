#!/bin/bash
#source ./tests/init.sh

TERRAFORM_SYMLINK_DIR="/usr/local/bin"
TERRAFORM_INSTALL_DIR="/usr/local/src"

check_packages() {
  set +e
  local pkgs=""
  command -v curl &> /dev/null || pkgs+=" curl"
  command -v unzip &> /dev/null || pkgs+=" unzip"
  set -e
  if [ ! -z $pkgs ]; then
    apt-get -y update && apt-get -y install $pkgs
  fi
}

main () {
  local version=$1
  local install_dir=$2
  if [[ $version == "current" ]]; then
    curl -Lo /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
    chmod +x /usr/local/bin/jq
    version=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r '.current_version' )
  fi
  if [ ! -f "${install_dir}/terraform_${version}_linux_amd64/terraform" ]; then
    check_packages
    info "Fetching Terraform..."
    curl -Lo "${install_dir}/terraform_${version}_linux_amd64.zip" \
            "https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_amd64.zip"
    info "Installing Terraform..."
    unzip -qo "${install_dir}/terraform_${version}_linux_amd64.zip" \
              -d "${install_dir}/terraform_${version}_linux_amd64"
    rm -f "${install_dir}/terraform_${version}_linux_amd64.zip"
  fi
  ln -sf "${install_dir}/terraform_${version}_linux_amd64/terraform" "${TERRAFORM_SYMLINK_DIR}/terraform"
}

# check properties
if [[ ! -n "${WERCKER_INSTALL_TERRAFORM_VERSION}" ]]; then
  fail "Please specify the version property"
fi

if [[ "${WERCKER_INSTALL_TERRAFORM_USE_CACHE}" == "true" ]]; then
  TERRAFORM_INSTALL_DIR="${WERCKER_CACHE_DIR}${TERRAFORM_INSTALL_DIR}"
fi
mkdir -p "${TERRAFORM_SYMLINK_DIR}"
mkdir -p "${TERRAFORM_INSTALL_DIR}"

main "${WERCKER_INSTALL_TERRAFORM_VERSION}" "${TERRAFORM_INSTALL_DIR}"
