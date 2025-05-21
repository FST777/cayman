#!/bin/sh
BODY="$(/usr/local/bin/cayman metrics)"
echo "Content-Type: text/plain"
echo "Content-Length: ${#BODY}"
echo
echo "${BODY}"
