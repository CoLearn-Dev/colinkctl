#!/bin/bash
set -e

if [ -z $COLINK_HOME ]; then
    COLINK_HOME="$HOME/.colink"
fi
mkdir -p $COLINK_HOME

echo "Install colinkctl to $COLINK_HOME"
if command -v curl > /dev/null ; then
    curl -fsSL https://raw.githubusercontent.com/CoLearn-Dev/colinkctl/main/colinkctl -o $COLINK_HOME/colinkctl
elif command -v wget > /dev/null ; then
    wget https://raw.githubusercontent.com/CoLearn-Dev/colinkctl/main/colinkctl -O $COLINK_HOME/colinkctl
else
    echo "command not found: wget or curl"
    exit 1
fi
chmod +x $COLINK_HOME/colinkctl
echo "Install colinkctl: done"
echo "Install CoLink server to $COLINK_HOME"
cd $COLINK_HOME
if command -v curl > /dev/null ; then
    curl -fsSL https://github.com/CoLearn-Dev/colink-server-dev/releases/latest/download/colink-server-linux-x86_64.tar.gz -o colink-server-linux-x86_64.tar.gz
elif command -v wget > /dev/null ; then
    wget https://github.com/CoLearn-Dev/colink-server-dev/releases/latest/download/colink-server-linux-x86_64.tar.gz -O colink-server-linux-x86_64.tar.gz
fi
tar -xzf colink-server-linux-x86_64.tar.gz
rm colink-server-linux-x86_64.tar.gz
cp user_init_config.template.toml user_init_config.toml
echo "Install colink-server: done"

read -r -p "Install RabbitMQ? [Y/n] " response
case "$response" in
    [nN][oO]|[nN])
        ;;
    *)
        sudo apt update && sudo apt install rabbitmq-server -y
        sudo rabbitmq-plugins enable rabbitmq_management
        sudo service rabbitmq-server restart
        ;;
esac

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
    echo "Install alias to $PROFILE"
    sed -i '/^alias colinkctl=/d' $PROFILE
    echo "alias colinkctl=\"$COLINK_HOME/colinkctl\"" >> $PROFILE
    echo "Reopen your terminal to start using colinkctl."
else
    echo "No profile is found, you need to go into $COLINK_HOME to use colinkctl."
fi

read -r -p "Start CoLink server now? [Y/n] " response
case "$response" in
    [nN][oO]|[nN])
        ;;
    *)
        $COLINK_HOME/colinkctl start
        ;;
esac
