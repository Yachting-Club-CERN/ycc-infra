# ARG KEYCLOAK_VERSION="23.0.7"
# ARG YCC_KEYCLOAK_PROVIDER_VERSION="1.1.0"

ARG KEYCLOAK_VERSION="24.0.5"
# ARG KEYCLOAK_VERSION="25.0.6"
# ARG KEYCLOAK_VERSION="26.1.4"
ARG YCC_KEYCLOAK_PROVIDER_VERSION="1.2.0"
# Improved version, see https://github.com/a8m/envsubst
ARG ENVSUBST_VERSION="v1.4.3"
# See https://github.com/Yachting-Club-CERN/ycc-infra/issues/8 and https://github.com/keycloak/keycloak/issues/17450
ARG ORACLE_VERSION="23.7.0.25.01"

ARG PACKAGE_REPOSITORY_BASE_PATH="maven.pkg.github.com/Yachting-Club-CERN/ycc-keycloak-provider/ch/cern/ycc/ycc-keycloak-provider"
# Anyway it is public, just GitHub still does not allow anonymous access to the Maven repositories
# Also now they scan repos for secrets... And even if you allow them, they block the access token!
ARG PACKAGE_REPOSITORY_AUTH1="ycc-bot:github_pat_11A6WKE6Q0U0EdleKbPeBa_trhvxDMh0"
ARG PACKAGE_REPOSITORY_AUTH2="If3YOotnztbptQxWLpAtURMHqx4iSTbmxcM37JVX46bzaAVPCN"

ARG KEYCLOAK_CERTIFICATE
ARG KEYCLOAK_CERTIFICATE_KEY

FROM quay.io/keycloak/keycloak:$KEYCLOAK_VERSION

ARG YCC_KEYCLOAK_PROVIDER_VERSION
ARG ENVSUBST_VERSION
ARG ORACLE_VERSION
ARG PACKAGE_REPOSITORY_AUTH1
ARG PACKAGE_REPOSITORY_AUTH2
ARG PACKAGE_REPOSITORY_BASE_PATH

ARG KEYCLOAK_CERTIFICATE
ARG KEYCLOAK_CERTIFICATE_KEY

# 1000 = keycloak uid (ref: https://github.com/keycloak/keycloak/blob/main/quarkus/container/Dockerfile)
ADD --chown=1000:0 --chmod=555 "https://github.com/a8m/envsubst/releases/download/$ENVSUBST_VERSION/envsubst-Linux-x86_64" "/usr/local/bin/envsubst"

ADD --chown=1000:0 --chmod=644 "https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc11/$ORACLE_VERSION/ojdbc11-$ORACLE_VERSION.jar" "/opt/keycloak/providers/ojdbc11.jar"
ADD --chown=1000:0 --chmod=644 "https://repo1.maven.org/maven2/com/oracle/database/nls/orai18n/$ORACLE_VERSION/orai18n-$ORACLE_VERSION.jar" "/opt/keycloak/providers/orai18n.jar"

ADD --chown=1000:0 --chmod=644 "https://$PACKAGE_REPOSITORY_AUTH1$PACKAGE_REPOSITORY_AUTH2@$PACKAGE_REPOSITORY_BASE_PATH/$YCC_KEYCLOAK_PROVIDER_VERSION/ycc-keycloak-provider-$YCC_KEYCLOAK_PROVIDER_VERSION.jar" "/opt/keycloak/providers/"
ADD --chown=1000:0 --chmod=644 "https://$PACKAGE_REPOSITORY_AUTH1$PACKAGE_REPOSITORY_AUTH2@$PACKAGE_REPOSITORY_BASE_PATH/$YCC_KEYCLOAK_PROVIDER_VERSION/ycc-keycloak-provider-$YCC_KEYCLOAK_PROVIDER_VERSION-ycc-db-dev.jar" "/opt/keycloak/providers/"
ADD --chown=1000:0 --chmod=644 "https://$PACKAGE_REPOSITORY_AUTH1$PACKAGE_REPOSITORY_AUTH2@$PACKAGE_REPOSITORY_BASE_PATH/$YCC_KEYCLOAK_PROVIDER_VERSION/ycc-keycloak-provider-$YCC_KEYCLOAK_PROVIDER_VERSION-ycc-db-test.jar" "/opt/keycloak/providers/"
ADD --chown=1000:0 --chmod=644 "https://$PACKAGE_REPOSITORY_AUTH1$PACKAGE_REPOSITORY_AUTH2@$PACKAGE_REPOSITORY_BASE_PATH/$YCC_KEYCLOAK_PROVIDER_VERSION/ycc-keycloak-provider-$YCC_KEYCLOAK_PROVIDER_VERSION-ycc-db-prod.jar" "/opt/keycloak/providers/"

RUN set -u && \
    mkdir -p "/opt/keycloak/certificate" && \
    echo -e "$KEYCLOAK_CERTIFICATE" > "/opt/keycloak/certificate/crt.pem" && \
    echo -e "$KEYCLOAK_CERTIFICATE_KEY" > "/opt/keycloak/certificate/key.pem"

COPY --chown=1000:0 "ycc-theme/" "/opt/keycloak/themes/ycc-theme"
COPY --chown=1000:0 "conf" "/opt/keycloak/conf"
COPY --chown=1000:0 "start.sh" "/opt/keycloak/start.sh"

ENTRYPOINT ["/opt/keycloak/start.sh"]
