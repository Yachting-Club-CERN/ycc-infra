# YCC Keycloak Container Image

This image is a specialized YCC keycloak image, tailored to for OKD usage. You can find a relevant guide [here](https://www.keycloak.org/server/containers).

Please also refer to the [CERN OKD Documentation](https://paas.docs.cern.ch/). It is a really cool PaaS service, compared to virtual machines we do not need to worry about trusted SSL certificates, networking/routing is a piece of cake (both CERN-only and public), logs are federated to OpenSearch, etc.

Some remarks though:

- You need a CERN account to have access to CERN OKD and YCC Keycloak Admin
- Secrets are not stored in Git. You can find them under OKD secrets

Upon any questions/issues, please contact Lajos.

_I am not an OKD expert, any feedback is welcome, I imagine there is a lot of room for improvement._

## Features (on top of Keycloak)

- Configuration templates in `conf/`
- Custom `start.sh`, which upon start fills the configuration templates from environment variables (such as database credentials stored as OKD secrets)
- Built-in [ycc-keycloak-provider](https://github.com/Yachting-Club-CERN/ycc-keycloak-provider/)

At the moment part of the configuration is happening in `start.sh`, which means that upon service restarts Keycloak needs ~30 seconds to rebuild the Quarkus application. (Reason: it was simpler to configure like this, could be improved when occasional service outages due to restarts should be limited.)

## Usage

The image is built & deployed by OKD. OKD has access to this repo through the `ycc-bot` GitHub service account/machine user.

### Testing Docker Build Locally

You can test the build locally. If you do not want to run the instance, but only inspect the contents, you can set the entry point in your local copy to `/bin/bash` for simplicity.

You can test the build with this command (with fake contents for certificates):

`docker build . -t ycc-keycloak-local-test --build-arg KEYCLOAK_CERTIFICATE=crt-test --build-arg KEYCLOAK_CERTIFICATE_KEY=key-test`

Then start a new container from the image (you can specify the environment variables if you want to also test `start.sh`):

`docker run -e KEYCLOAK_DB_USERNAME=? -it ycc-keycloak-local-test`

## Security

The container uses a self-signed certificate, which is specified during OKD build and built in the container. This certificate secures communication inside OKD. OKD routes are configured for TLS re-encryption, so the exposed paths are secured with CERN OKD certificates.

## OKD Configuration

This is a shortlist, for details please refer to the `ycc-auth` CERN OKD namespace.

- `ycc-keycloak` deployment & service
- Public routes for `ycc-auth.web.cern.ch`
- CERN-only routes for `ycc-auth-admin.web.cern.ch`
- BuildConfig for building the `ycc-keycloak` Docker image
- Credentials, private resources as secrets

For networking OKD routes are used instead of Kubernetes Ingress, since the former supports TSL re-encryption.

The container build is a manual click (you choose when to build the image), but after the build the service is automatically redeployed (<1 min downtime). Scaling is not tested and probably will not be required, so please stick to maximum 1 pod.

### Configuration Backup

Run `oc get all,secrets -o yaml > ycc-auth-with-secrets.yml` to export all configuration with secrets. The generated should be handle as confidential.
