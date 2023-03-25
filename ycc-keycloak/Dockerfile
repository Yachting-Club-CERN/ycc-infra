ARG KEYCLOAK_VERSION="21.0.1"
ARG YCC_KEYCLOAK_PROVIDER_VERSION="0.1.0"
# Improved version, see https://github.com/a8m/envsubst
ARG ENVSUBST_VERSION="v1.4.2"
# See https://github.com/Yachting-Club-CERN/ycc-infra/issues/8 and https://github.com/keycloak/keycloak/issues/17450
ARG KEYCLOAK_ORACLE_VERSION="21.5.0.0"

ARG PACKAGE_REPOSITORY_BASE_PATH="https://maven.pkg.github.com/Yachting-Club-CERN/ycc-keycloak-provider/ch/cern/ycc/ycc-keycloak-provider"
ARG PACKAGE_REPOSITORY_AUTH="ycc-bot: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" # Anyway this is public, but the public links are cumbersome cloud links

FROM registry.access.redhat.com/ubi9-minimal as resources
ARG ENVSUBST_VERSION
ARG YCC_KEYCLOAK_PROVIDER_VERSION
ARG KEYCLOAK_ORACLE_VERSION
ARG PACKAGE_REPOSITORY_BASE_PATH
ARG PACKAGE_REPOSITORY_AUTH
RUN curl -L "https://github.com/a8m/envsubst/releases/download/$ENVSUBST_VERSION/envsubst-Linux-x86_64" \
        -o "/usr/local/bin/envsubst" && \
    chmod +x "/usr/local/bin/envsubst" && \
    mkdir -p "/tmp/providers" && \
    curl -L -u "$PACKAGE_REPOSITORY_AUTH" \
        "$PACKAGE_REPOSITORY_BASE_PATH/$YCC_KEYCLOAK_PROVIDER_VERSION/ycc-keycloak-provider-$YCC_KEYCLOAK_PROVIDER_VERSION{,-ycc-db-test}.jar" \
        -o "/tmp/providers/ycc-keycloak-provider-$YCC_KEYCLOAK_PROVIDER_VERSION#1.jar" && \
    mkdir -p "/tmp/extra-libs" && \
    curl -L "https://repo1.maven.org/maven2/com/oracle/database/nls/orai18n/$KEYCLOAK_ORACLE_VERSION/orai18n-$KEYCLOAK_ORACLE_VERSION.jar" \
        -o "/tmp/extra-libs/com.oracle.database.nls.orai18n-$KEYCLOAK_ORACLE_VERSION.jar"

FROM quay.io/keycloak/keycloak:$KEYCLOAK_VERSION

COPY --from=resources "/usr/local/bin/envsubst" "/usr/local/bin/"
COPY --from=resources "/tmp/providers/"* "/opt/keycloak/providers"
COPY --from=resources "/tmp/extra-libs/"* "/opt/keycloak/providers"
COPY "conf" "/opt/keycloak/conf"
COPY "start.sh" "/opt/start.sh"

ENTRYPOINT ["/opt/start.sh"]
