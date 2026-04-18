#!/bin/bash
echo hello

exec /usr/bin/dumb-init -- /entrypoint $@
