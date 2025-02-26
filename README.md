# Lua scripts for deploying Stackrox Central

This is an incomplete hackathon project for deploying
[Stackrox](https://stackrox.io) using
[kluars](https://github.com/molter73/kluars)

## Running

Clone and install kluars with the following commands (requires you to
have rust and cargo installed):
```sh
git clone https://github.com/molter73/kluars
cargo install --path kluars
```

Get the required certificates for running Stackrox Central. I got them
by running the deploy-local.sh script from
https:/github.com/stackrox/stackrox and ripping them out of there and
into the `secrets` directory in this repo (yes, I'm aware deploying
stackrox normally in order to deploy it with this repo sort of
defeats the purpose, I'll try to make it so the certs are somehow
generated here, but no promises).

Use the `xlate` subcommand from kluars to render the required manifests
and pipe them into kubectl:
```sh
kluars xlate lua | kubectl apply -f -
```

That's it! Central should be deployed.

## Changing images being used

The following arguments can be used to change the images for central
and central-db:
- main_registry
- main_name
- main_tag
- main_fullRef
- db_registry
- db_name
- db_tag
- db_fullRef

An example using `quay.io/rhacs-eng` instead of the regular
`quay.io/stackrox-io` registry could look like this:
```sh
kluars xlate -a main_registry=quay.io/rhacs-eng -e db_registry=quay.io/rhacs-eng | kubectl apply -f -
```
