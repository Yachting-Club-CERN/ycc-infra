#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd)"
source "$SCRIPT_DIR/config.sh"

"$SCRIPT_DIR/keycloak-$KEYCLOAK_VERSION/bin/kc.sh" "$@"
