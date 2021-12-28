#!/bin/sh -e
# Magical Entrypoint
# Brian Dwyer - Broadridge Financial Solutions

# CDKTF Wrapper & Passthrough
case "$1" in
        deploy|destroy|diff|get|init|login|synth|help) cdktf "$@";;
        -*)     cdktf "$@";;
        * )	exec "$@";;
esac
