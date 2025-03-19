#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd)"

KEYCLOAK_VERSION=26.1.4
# Use LOCAL for using local build output (useful for development), exact version to download from the package repository
YCC_KEYCLOAK_PROVIDER_VERSION="1.2.0"
ORACLE_DRIVER_VERSION="23.7.0.25.01"

# Ideal for flat Git repo clone layout
YCC_KEYCLOAK_PROVIDER_LOCAL_DIRECTORY="$SCRIPT_DIR/../../ycc-keycloak-provider/build/libs"

PACKAGE_REPOSITORY_BASE_PATH="https://maven.pkg.github.com/Yachting-Club-CERN/ycc-keycloak-provider/ch/cern/ycc/ycc-keycloak-provider"

# Anyway it is public, just GitHub still does not allow anonymous access to the Maven repositories
# Also now they scan repos for secrets... And even if you allow them, they block the access token!
PACKAGE_REPOSITORY_AUTH1="ycc-bot:github_pat_11A6WKE6Q0U0EdleKbPeBa_trhvxDMh0"
PACKAGE_REPOSITORY_AUTH2="If3YOotnztbptQxWLpAtURMHqx4iSTbmxcM37JVX46bzaAVPCN"
PACKAGE_REPOSITORY_AUTH="$PACKAGE_REPOSITORY_AUTH1$PACKAGE_REPOSITORY_AUTH2"