#!/bin/bash

prompt() {
    while [[ "${response}" != "y" ]] && [[ "${response}" != "yes" ]] && \
            [[ "${response}" != "n" ]] && [[ "${response}" != "no" ]]; do
        printf "%s  [y/n]: " "$1"
        read -r response
    done

    if [ "${response}" != "y" ] && [ "${response}" != "yes" ]; then
        exit 1
    fi
}
