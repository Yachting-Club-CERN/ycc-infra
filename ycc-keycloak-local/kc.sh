#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd)"
source "$SCRIPT_DIR/config.sh"

"keycloak-$KEYCLOAK_VERSION/bin/kc.sh" "$@"
