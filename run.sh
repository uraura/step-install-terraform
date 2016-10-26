#!/bin/bash

set -x

error_exit() {
    local message=$1

    echo "[FATAL] $message" 1>&2
    exit 1
}

download_terraform() {
  local install_path=$1
  local version=$2
  if [ ! -f "${install_path}/terraform_${version}_linux_amd64/terraform" ]; then
    wget -qO ${install_path}/terraform_${version}_linux_amd64.zip https://releases.hashicorp.com/terraform/${version}/terraform_${version}_linux_amd64.zip
    unzip -qo "${install_path}/terraform_${version}_linux_amd64.zip" -d "${install_path}/terraform_${version}_linux_amd64"
    rm -f ${install_path}/terraform_${version}_linux_amd64.zip
  fi
  ln -sf ${install_path}/terraform_${version}_linux_amd64/terraform ${install_path}/bin/terraform
  return 0
}

# check properties
if [ ! -n "${WERCKER_INSTALL_TERRAFORM_VERSION}" ]; then
  error_exit 'Please specify the version property'
fi

# default
# ${HOME}/jyotti/bin/terraform
# ${HOME}/jyotti/terraform_x.x.x/terraform
# cache
# ${WERCKER_CACHE_DIR}/jyotti/bin/terraform
# ${WERCKER_CACHE_DIR}/jyotti/terraform_x.x.x/terraform
INSTALL_PATH=""
if [ -n ${WERCKER_INSTALL_TERRAFORM_USE_CACHE} -a ${WERCKER_INSTALL_TERRAFORM_USE_CACHE} == "true" ]; then
  INSTALL_PATH=${WERCKER_CACHE_DIR}/github/jyotti
else
  INSTALL_PATH=${HOME}/github/jyotti
fi
mkdir -p ${INSTALL_PATH}/bin
PATH=${PATH}:${INSTALL_PATH}/bin
download_terraform ${INSTALL_PATH} ${WERCKER_INSTALL_TERRAFORM_VERSION}
