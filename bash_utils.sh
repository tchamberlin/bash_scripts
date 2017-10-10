#!/bin/bash

###
# Author: Thomas Chamberlin
#
# "Utility" function library
###

BGreen="\e[1;32m"
Color_Off="\e[0m"
BYellow="\e[1;33m"
BRed="\e[1;31m"
BBlue="\e[1;34m"


log_green() {
    echo -e "$BGreen--- $1 ---$Color_Off"
}

log_blue() {
    echo -e "$BBlue--- $1 ---$Color_Off"
}

log_yellow() {
    echo -e "$BYellow--- $1 ---$Color_Off"
}

log_red() {
    echo -e "$BRed--- $1 ---$Color_Off"
}

log_info() {
    echo -e "$BGreen--- $1 ---$Color_Off"
}

log_warning() {
    log_yellow "WARNING: $1" >&2
}

log_error() {
    log_red "ERROR: $1" >&2
}

print_separator() {
    # TODO: Base this on terminal width
    log_green "---------------------------------"
}

# Print the error and then exit with the (optional) given code
fatal_error() {
    if [ -n "$1" ]; then
        local reason="$1"
    else
        local reason="No reason given"
    fi
    if [ -n "$2" ]; then
        local code=$2
    else
        # Default to `1` as exit code
        local code=1
    fi
    log_error "$reason"
    exit $code
}


handle_error() {
    if [ $? -ne 0 ]; then
        fatal_error "$1" "$2"
    fi
}

# Given a command, execute it then check it for errors. Assumes that 0
# is "success" and that any quotes are properly escaped
#   Arg 1: command
#   Arg 2: line number (optional)
safe_cmd() {
    log_blue "Executing: \"${1}\""
    # If user has requested a dry run, don't actually execute any commands
    if [ -z "$dryrun" ]; then
        eval "${1}"
        handle_error "${1} failed!" "$2"
    fi
}

script_cmd() {
    log_blue "Executing: \"${1}\""
    # If user has requested a dry run, don't actually execute any commands
    if [ -z "$dryrun" ]; then
        eval "${1}"
        # Make it clear that we're returning the exit code from the eval
        return $?
    fi
}

# Print the given prompt, read the result. Repeat until valid response is
# given. Then exit with failure code if response isn't y/yes
prompt() {
    while [[ "${response}" != "y" ]] && [[ "${response}" != "yes" ]] && \
[[ "${response}" != "n" ]] && [[ "${response}" != "no" ]]; do
        log_yellow "${1}  [y/n]: "
        read -r response
    done

    if [ "${response}" != "y" ] && [ "${response}" != "yes" ]; then
        fatal_error "Prompt failed; exiting"
    fi
}

scriptdir() {
    # TODO: Still not sure about the -1...
    readlink -f "${BASH_SOURCE[${#BASH_SOURCE[@]}-1]}"
}
