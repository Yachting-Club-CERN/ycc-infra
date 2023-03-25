# YCC Infrastructure

This repo holds infrastructure related documentation and resources.

## Environments
## `ycc-keycloak*`

According to the [Keycloak](https://www.keycloak.org/) website:

> _Open Source Identity and Access Management_
>
> Add authentication to applications and secure services with minimum effort. No need to deal with storing users or authenticating users.
>
> Keycloak provides user federation, strong authentication, user management, fine-grained authorization, and more.

In the YCC use case Keycloak brings us authentication, authorization and SSO. Thanks to `ycc-keycloak-provider` our existing Oracle database is federated to our Keycloak instance. Keycloak also supports OpenID Connect, which we use for authentication in our NextGen applications and components.

## `ycc-db*`

The new system uses the existing Oracle database (hosted at CERN). This is mainly for migration reasons.

To connect to the database programmatically (both local and remote) you will need to install [Oracle Instant Client](https://www.oracle.com/uk/database/technologies/instant-client/downloads.html).

To inspect the database, best is to use [SQL Developer](https://www.oracle.com/database/technologies/appdev/sqldeveloper-landing.html). Modern IDEs also have data browser extensions.

### Database Schema Upgrade

As the DB changes, you need to update to Docker and other non-PRO databases. This is what I found a relatively simple workflow:

1. Export schema:
   1. Open Oracle SQL Developer
   2. Connect to YCC DB (outside of CERN you can tunnel to Oracle with extra port forwarding)
   3. Select `Top Menu -> Tools -> Database Export...`
   4. Export DDL (without data) to a single UTF-8 file (it can take a few minutes)
   5. Save it to the `db/` directory, e.g., `db/schema-export-2023-02.sql`
   6. Double check that it has no sensitive and personal data in it
2. Check what changed (diff against previous version)
3. Port changes to `ycc-db-local/init/sql/schema-local.sql.noautorun`
   1. In the Local Docker Database we do not store table storage constraints and grants
   2. If there are many changes, the best is to diff one or two more times in order to eliminate mistakes
4. Test the local schema by deleting and recreating the Docker container
5. Update `ycc-hull` and other components if necessary

## `ycc-bot` GitHub account

This service account/machine user is member of the organisation and is used for package publishing, so no human needs to give a private access token (classic) to the organisation. As of 2023-03 it seemed that for publishing from CI a private access token (classic) is needed, which I could not limit to this GitHub organisation.

(Ask Lajos for more details.)
