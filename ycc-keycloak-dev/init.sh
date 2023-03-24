#!/bin/bash
set -eu
SCRIPT_DIR="$( cd "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd)"
source "$SCRIPT_DIR/config.sh"

KC_DIST_FILE_NAME="keycloak-$KEYCLOAK_VERSION.zip"
KC_DIST="$SCRIPT_DIR/$KC_DIST_FILE_NAME"
KC_DIR="$SCRIPT_DIR/keycloak-$KEYCLOAK_VERSION"
KC_CONF_SOURCE="$SCRIPT_DIR/conf"
KC_CONF_TARGET="$KC_DIR/conf"

# Downlaod Keycloak
if [ -f "$KC_DIST" ]; then
    echo "> Found Keycloak download"
else
    echo "> Downloading Keycloak..."
    wget "https://github.com/keycloak/keycloak/releases/download/$KEYCLOAK_VERSION/$KC_DIST_FILE_NAME"
fi
echo ""

# Unpack Keycloak
if [ -d "$KC_DIR" ]; then
    echo "> Found Keycloak directory"
else
    echo "> Unpacking Keycloak..."
    unzip "$KC_DIST"
    cp "$KC_CONF_TARGET/keycloak.conf" "$KC_CONF_TARGET/keycloak.conf.default"
fi
echo ""

# Copy Keycloak configuration
echo "> Copying $KC_CONF_SOURCE to $KC_CONF_TARGET"
cp -r "$KC_CONF_SOURCE/"* "$KC_CONF_TARGET"
echo ""

# Install providers
echo ""
echo "> Installing ycc-keycloak-provider $YCC_KEYCLOAK_PROVIDER_VERSION"
echo ""

remove_provider () {
    echo ">> Removing existing ycc-keycloak-provider ..."
    rm -f "$KC_DIR/providers/ycc-keycloak-provider"*.jar
}

if [ "$YCC_KEYCLOAK_PROVIDER_VERSION" == "LOCAL" ]; then
    if [ -d "$YCC_KEYCLOAK_PROVIDER_LOCAL_DIRECTORY" ]; then
        remove_provider

        echo ">> Copying providers from $YCC_KEYCLOAK_PROVIDER_LOCAL_DIRECTORY ..."
        echo "$(ls "$YCC_KEYCLOAK_PROVIDER_LOCAL_DIRECTORY" | grep -Ev "javadoc|sources|ycc-db-test|ycc-db-prod")" | while read -r f; do
            echo ">>> Copying $f ..."
            cp "$YCC_KEYCLOAK_PROVIDER_LOCAL_DIRECTORY/$f" "$KC_DIR/providers"
        done
    else
        echo ">> $YCC_KEYCLOAK_PROVIDER_LOCAL_DIRECTORY not found, did not change providers"
    fi
else
    remove_provider

    echo ""
    echo ">> Downloading providers from $PACKAGE_REPOSITORY_BASE_PATH ..."
    echo ""

    (
        cd "$KC_DIR/providers"
        wget "--user=$PACKAGE_REPOSITORY_USERNAME" "--password=$PACKAGE_REPOSITORY_PASSWORD" \
            "$PACKAGE_REPOSITORY_BASE_PATH/$YCC_KEYCLOAK_PROVIDER_VERSION/ycc-keycloak-provider-$YCC_KEYCLOAK_PROVIDER_VERSION.jar" \
            "$PACKAGE_REPOSITORY_BASE_PATH/$YCC_KEYCLOAK_PROVIDER_VERSION/ycc-keycloak-provider-$YCC_KEYCLOAK_PROVIDER_VERSION-ycc-db-local.jar"
    )
fi

echo ""
echo "> Done"
