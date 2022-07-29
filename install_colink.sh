#!/bin/bash
set -e

if [ -z $COLINK_HOME ]; then
    COLINK_HOME="$HOME/.colink"
fi
mkdir -p $COLINK_HOME

PAYLOAD_LINE=$(awk '/^__PAYLOAD_BEGINS__/ { print NR + 1; exit 0; }' $0)

# tail -n +${PAYLOAD_LINE} $0 | tar -px -C $COLINK_HOME

$COLINK_HOME/colinkctl install

PROFILE=""
if [ -f "$HOME/.bashrc" ]; then
    PROFILE="$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
    PROFILE="$HOME/.bash_profile"
elif [ -f "$HOME/.zshrc" ]; then
    PROFILE="$HOME/.zshrc"
elif [ -f "$HOME/.profile" ]; then
    PROFILE="$HOME/.profile"
fi

if [ ! -z $PROFILE ]; then
    echo "Installing alias to $PROFILE"
    echo "alias colinkctl=\"$COLINK_HOME/colinkctl\"" >> $PROFILE
    echo "Reopen your terminal to start using colinkctl."
else
    echo "No profile is found, you need to go into $COLINK_HOME to use colinkctl."
fi

exit 0
__PAYLOAD_BEGINS__
