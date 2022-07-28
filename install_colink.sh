#!/bin/bash
set -e

if [ -z $COLINK_HOME ]; then
    COLINK_HOME="$HOME/.colink"
fi
mkdir -p $COLINK_HOME
cd $COLINK_HOME

PAYLOAD_LINE=$(awk '/^__PAYLOAD_BEGINS__/ { print NR + 1; exit 0; }' $0)

tail -n +${PAYLOAD_LINE} $0 | tar -px -C $COLINK_HOME



exit 0
__PAYLOAD_BEGINS__
