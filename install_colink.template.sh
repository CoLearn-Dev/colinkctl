#!/bin/bash
set -e

read -r -p "Install dependencies? [Y/n] " response
case "$response" in
    [nN][oO]|[nN])
        ;;
    *)
        sudo apt update && sudo apt install git g++ cmake pkg-config libssl-dev protobuf-compiler lsof -y
        if ! [ -x "$(command -v cargo)" ]; then
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            source $HOME/.cargo/env
            rustup default stable
        fi
        read -r -p "Install RabbitMQ? [Y/n] " response
        case "$response" in
            [nN][oO]|[nN])
                ;;
            *)
                sudo apt install rabbitmq-server -y
                sudo rabbitmq-plugins enable rabbitmq_management
                sudo systemctl restart rabbitmq-server.service
                ;;
        esac
        ;;
esac

if [ -z $COLINK_HOME ]; then
    COLINK_HOME="$HOME/.colink"
fi
mkdir -p $COLINK_HOME

PAYLOAD_LINE=$(awk '/^__PAYLOAD_BEGINS__/ { print NR + 1; exit 0; }' $0)

tail -n +${PAYLOAD_LINE} $0 | tar -px -C $COLINK_HOME

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
    sed -i '/^alias colinkctl=/d' $PROFILE
    echo "alias colinkctl=\"$COLINK_HOME/colinkctl\"" >> $PROFILE
    echo "Reopen your terminal to start using colinkctl."
else
    echo "No profile is found, you need to go into $COLINK_HOME to use colinkctl."
fi

exit 0
__PAYLOAD_BEGINS__
