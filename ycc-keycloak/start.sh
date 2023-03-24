#!/bin/bash
set -e

echo "Preparing keycloak.conf ..."
envsubst -no-empty -no-unset  < "/opt/keycloak/conf/keycloak.conf.template" > "/opt/keycloak/conf/keycloak.conf"

echo "Preparing quarkus.properties ..."
envsubst -no-empty -no-unset  < "/opt/keycloak/conf/quarkus.properties.template" > "/opt/keycloak/conf/quarkus.properties"

echo "Starting Keycloak..."
"/opt/keycloak/bin/kc.sh" "$@"
