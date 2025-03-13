#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd)"

KEYCLOAK_VERSION=22.0.4
# Use LOCAL for using local build output (useful for development), exact version to download from the package repository
YCC_KEYCLOAK_PROVIDER_VERSION="1.1.0"
# Ideal for flat Git repo clone layout
YCC_KEYCLOAK_PROVIDER_LOCAL_DIRECTORY="$SCRIPT_DIR/../../ycc-keycloak-provider/build/libs"

PACKAGE_REPOSITORY_BASE_PATH="https://maven.pkg.github.com/Yachting-Club-CERN/ycc-keycloak-provider/ch/cern/ycc/ycc-keycloak-provider"
# Anyway this is public, but the public links are cumbersome cloud links
PACKAGE_REPOSITORY_AUTH="ycc-bot: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"
