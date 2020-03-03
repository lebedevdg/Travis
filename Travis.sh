#!/bin/bash -x

set +e

RED="\033[0;31m"
GREEN="\033[0;32m"
DARKYELLOW="\033[0;33m"
CYAN="\033[0;36m"
LIGHTGRAY="\033[0;37m"

BRANCH="${TRAVIS_BRANCH:-master}"
BRANCH_TO_TEST="${BRANCH_TO_TEST:-master}"
# debug:
#BRANCH_TO_TEST=$BRANCH

if [ "$BRANCH" != "$BRANCH_TO_TEST" ]
then
  echo -e "${DARKYELLOW}Nothing to do for ${BRANCH} branch${LIGHTGRAY}"
  exit 0
fi

sudo apt-get update -qq > /dev/null
sudo apt-get upgrade -yqq > /dev/null
sudo apt-get install -yqq tree curl unzip grep > /dev/null

PACKER_VERSION=1.5.4
TERRAFORM_VERSION=0.12.21
TFLINT_VERSION=0.14.0
ANSIBLE_VERSION=2.9.5
ANSIBLE_LINT_VERSION=4.2.0

mkdir -p _tmp && cd _tmp

# Install packer
curl -OsS https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
  unzip -oq packer_${PACKER_VERSION}_linux_amd64.zip && \
  rm -f packer_${PACKER_VERSION}_linux_amd64.zip && \
  sudo mv -f packer /usr/local/bin && \
  sudo chmod +x /usr/local/bin/packer

# Install terraform
curl -OsS https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  unzip -oq terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  sudo mv -f terraform /usr/local/bin && \
  sudo chmod +x /usr/local/bin/terraform
  
  # Install tflint
curl -OLsS https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip && \
  unzip -oq tflint_linux_amd64.zip && \
  rm -r tflint_linux_amd64.zip && \
  sudo mv -f tflint /usr/local/bin && \
  sudo chmod +x /usr/local/bin/tflint

cd .. && rm -rf _tmp

# Install ansible and ansible-lint
sudo -H pip install -q ansible==${ANSIBLE_VERSION} ansible-lint==${ANSIBLE_LINT_VERSION}
