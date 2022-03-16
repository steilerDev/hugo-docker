#!/bin/bash

echo "Building hugo site..."

./create-thumbs.sh && \
    ./build-hugo.sh && \
    ./encrypt-site.sh &&
    echo "Successfully build hugo site!"
