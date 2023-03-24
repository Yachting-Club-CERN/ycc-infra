# YCC Keycloak Container Image

This image is a specialized YCC keycloak image, tailored to used in OKD. You can find a relevant guide [here](https://www.keycloak.org/server/containers).

## Features (on top of Keycloak)

- Configuration templates in `conf/`
- Custom `start.sh`, which upon start fills the configuration templates from environment variables (such as database credentials stored as OKD secrets)
- Built-in [ycc-keycloak-provider](https://github.com/Yachting-Club-CERN/ycc-keycloak-provider/)

_I am an OKD beginner, any feedback is welcome, I imagine there is a lot of room for improvement._

## Usage

The image is built & deployed by OKD. OKD has access to this repo through the `ycc-bot` GitHub service account/machine user.
