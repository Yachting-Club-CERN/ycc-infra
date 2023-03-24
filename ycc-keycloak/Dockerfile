ARG KEYCLOAK_VERSION="21.0.1"
ARG YCC_KEYCLOAK_PROVIDER_VERSION="0.1.0"
# Improved version, see https://github.com/a8m/envsubst
ARG ENVSUBST_VERSION="v1.4.2"

ARG PACKAGE_REPOSITORY_BASE_PATH="https://maven.pkg.github.com/Yachting-Club-CERN/ycc-keycloak-provider/ch/cern/ycc/ycc-keycloak-provider"
ARG PACKAGE_REPOSITORY_AUTH="ycc-bot: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" # Anyway this is public, but the public links are cumbersome cloud links

FROM registry.access.redhat.com/ubi9-minimal as resources
ARG ENVSUBST_VERSION
ARG YCC_KEYCLOAK_PROVIDER_VERSION
ARG PACKAGE_REPOSITORY_BASE_PATH
ARG PACKAGE_REPOSITORY_AUTH
RUN curl -L -o "/usr/local/bin/envsubst" "https://github.com/a8m/envsubst/releases/download/$ENVSUBST_VERSION/envsubst-Linux-x86_64" && \
    chmod +x "/usr/local/bin/envsubst" && \
    mkdir -p "/tmp/providers" && \
    curl -L -u "$PACKAGE_REPOSITORY_AUTH" \
    "$PACKAGE_REPOSITORY_BASE_PATH/$YCC_KEYCLOAK_PROVIDER_VERSION/ycc-keycloak-provider-$YCC_KEYCLOAK_PROVIDER_VERSION{,-ycc-db-test}.jar" \
    -o "/tmp/providers/ycc-keycloak-provider-$YCC_KEYCLOAK_PROVIDER_VERSION#1.jar"

FROM quay.io/keycloak/keycloak:$KEYCLOAK_VERSION

COPY --from=resources "/usr/local/bin/envsubst" "/usr/local/bin/"
COPY --from=resources "/tmp/providers"* "/opt/keycloak/providers"
COPY "conf" "/opt/keycloak/conf"
COPY "start.sh" "/opt/start.sh"

ENTRYPOINT ["/opt/start.sh"]
