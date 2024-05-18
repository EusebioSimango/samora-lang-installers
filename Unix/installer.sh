#!/bin/bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if curl is installed
if ! command_exists curl; then
  echo "install curl to proceed"
  echo "exiting..."
  exit
fi

if ! command_exists samora; then
  sudo mv $(which samora)
fi

temp_dir=$(mktemp -d)
echo "Temporary directory: $temp_dir"

LATEST_SML_RELEASE=$(curl -s https://api.github.com/repos/GraHms/Samora-Lang/releases/latest | jq -r '{tag: .tag_name, assets: .assets}')

LATEST_SML_VERSION=$(echo $LATEST_SML_RELEASE | jq -r '.tag' | sed 's/^v//')

LATEST_VERSION_FILE_NAME=$(echo "samora-lang_${LATEST_SML_VERSION}_linux_amd64.tar.gz")

LATEST_SML_FILE_URL=$(echo $LATEST_SML_RELEASE | jq -r '.assets[] .browser_download_url' | grep $LATEST_VERSION_FILE_NAME)

cd "$temp_dir"

curl ${LATEST_SML_FILE_URL} -sLO

tar -xzf ./${LATEST_VERSION_FILE_NAME}

sudo cp samora-lang /usr/local/bin/samora

chmod +x /usr/local/bin/samora

if command_exists samora; then
  echo "Delete temporary directory..."
  rm -rf $temp_dir
  echo "Installation Completed."
else
  echo "Something went wrong during the installation."
fi

