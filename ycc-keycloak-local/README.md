# YCC Keycloak (Local Development Mode)

It is faster to explore/develop Keycloak with a simple local instance - it needs Java to be present on your machine though.

Use the `*.sh` scripts at your convenience.

- Configuration is in `conf/`
- `init.sh` only downloads and unpacks Keycloak once, but it always applies configuration and provider changes
- Make sure to also check out `ycc-keycloak-provider` to see how user federation is done

## Quick Start

1. Start a `ycc-db-local` instance
2. Run `init.sh`
3. Run `kc.sh --start-dev`
