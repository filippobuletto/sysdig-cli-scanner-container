# sysdig-cli-scanner-container

Container image for Sysdig CLI Scanner.

[![Check and Update Version](https://github.com/filippobuletto/sysdig-cli-scanner-container/actions/workflows/check-update-version.yml/badge.svg)](https://github.com/filippobuletto/sysdig-cli-scanner-container/actions/workflows/check-update-version.yml)
[![Update image](https://github.com/filippobuletto/sysdig-cli-scanner-container/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/filippobuletto/sysdig-cli-scanner-container/actions/workflows/docker-publish.yml)

## Usage

### Volumes

Mounting the `/cache` directory is optional, whether it has been done make sure it is writable by the user with id/gid `1000/1000`.

### Environment variables

| Variable               | Description                     | Optional           |
|------------------------|---------------------------------|:------------------:|
| SECURE_API_TOKEN       | Secret containing the API-Token |                    |
| SYSDIG_SECURE_ENDPOINT | Sysdig Secure Endpoint          |                    |
| IMAGE_NAME             | Name of the image to be scanned |                    |
| OPTIONS                | Command line [parameters](https://docs.sysdig.com/en/docs/sysdig-secure/vulnerabilities/pipeline/#parameters)         | :white_check_mark: |

### Startup commands

Default values are:

```
--apiurl ${SYSDIG_SECURE_ENDPOINT}
--console-log
--dbpath=/cache/db/
--cachepath=/cache/scanner-cache/
${OPTIONS:- --skipupload --full-vulns-table --detailed-policies-eval}
${IMAGE_NAME}
```

### Examples

```bash
docker run --rm -it \
  -v ${TMPDIR:-/tmp}:/cache
  -e SECURE_API_TOKEN=$SECURE_API_TOKEN \
  -e SYSDIG_SECURE_ENDPOINT=<sysdig-api-url> \
  -e IMAGE_NAME=<image-name> \
  -e OPTIONS="--skipupload" \
  ghcr.io/filippobuletto/sysdig-cli-scanner
```

or you can inline the command line parameters

```bash
docker run --rm -it \
  -v ${TMPDIR:-/tmp}:/cache
  -e SECURE_API_TOKEN=$SECURE_API_TOKEN \
  ghcr.io/filippobuletto/sysdig-cli-scanner \
  --apiurl <sysdig-api-url> \
  --console-log \
  --dbpath=/cache/db/ \
  --cachepath=/cache/scanner-cache/ \
  --skipupload \
  <image-name>
```

You can also mount the docker/podman/containerd socket for local scanning.

## Notice of Non-Affiliation and Disclaimer

I am not affiliated, associated, authorized, endorsed by, or in any way officially connected with sysdig.com, Inc., or any of its subsidiaries or its affiliates. The official sysdig.com, Inc. website can be found at [https://sysdig.com](https://sysdig.com).