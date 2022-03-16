#!/bin/bash

if [ ! -z ${CRYPT_PWD} ]; then
    find /site/secret -type f -name "*.html" -exec ${NODE_BINARY_BASE}/node ${NODE_BINARY_BASE}/staticrypt {} ${CRYPT_PWD} -e -o {} -f /site/encryption_template.html \; && rm /site/encryption_template.html
else 
    echo "No crypt password found, skipping staticrypt"
fi
