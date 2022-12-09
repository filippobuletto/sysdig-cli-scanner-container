#!/bin/sh
echo "Scanner parameters: [$(eval echo "$@")]"
exec /scanner/sysdig-cli-scanner $(eval echo "$@")