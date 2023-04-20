#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd)"

KEYCLOAK_VERSION=21.0.1
# Use LOCAL for using local build output (useful for development), exact version to download from the package repository
YCC_KEYCLOAK_PROVIDER_VERSION="0.4.0"
# Ideal for flat Git repo clone layout
YCC_KEYCLOAK_PROVIDER_LOCAL_DIRECTORY="$SCRIPT_DIR/../../ycc-keycloak-provider/build/libs"

PACKAGE_REPOSITORY_BASE_PATH="https://maven.pkg.github.com/Yachting-Club-CERN/ycc-keycloak-provider/ch/cern/ycc/ycc-keycloak-provider"
PACKAGE_REPOSITORY_AUTH="ycc-bot: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" # Anyway this is public, but the public links are cumbersome cloud links
