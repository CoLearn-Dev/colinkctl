#!/bin/bash
set -e

SERVER_ONLY=false
SILENT_MODE=false
for i in "$@"; do
  case $i in
    --silent)
      SILENT_MODE=true
      ;;
    --server-only)
      SERVER_ONLY=true
      ;;
    -*|--*)
      echo "Unknown option $i"
      exit 1
      ;;
    *)
      ;;
  esac
done

print_str () {
    if [ "$SILENT_MODE" = "false" ] ; then
        echo $1
    fi
}

if [ -z $COLINK_HOME ]; then
    COLINK_HOME="$HOME/.colink"
fi
mkdir -p $COLINK_HOME

if [ "$SERVER_ONLY" = "false" ] ; then
    print_str "Install colinkctl to $COLINK_HOME"
    if command -v curl > /dev/null ; then
        curl -fsSL https://raw.githubusercontent.com/CoLearn-Dev/colinkctl/main/colinkctl -o $COLINK_HOME/colinkctl
    elif command -v wget > /dev/null ; then
        wget https://raw.githubusercontent.com/CoLearn-Dev/colinkctl/main/colinkctl -O $COLINK_HOME/colinkctl
    else
        print_str "command not found: wget or curl"
        exit 1
    fi
    chmod +x $COLINK_HOME/colinkctl
    print_str "Install colinkctl: done"
fi

print_str "Install CoLink server to $COLINK_HOME"
cd $COLINK_HOME
if command -v curl > /dev/null ; then
    curl -fsSL https://github.com/CoLearn-Dev/colink-server-dev/releases/latest/download/colink-server-linux-x86_64.tar.gz -o colink-server-linux-x86_64.tar.gz
elif command -v wget > /dev/null ; then
    wget https://github.com/CoLearn-Dev/colink-server-dev/releases/latest/download/colink-server-linux-x86_64.tar.gz -O colink-server-linux-x86_64.tar.gz
fi
tar -xzf colink-server-linux-x86_64.tar.gz
rm colink-server-linux-x86_64.tar.gz
cp user_init_config.template.toml user_init_config.toml
print_str "Install colink-server: done"

if [ "$SILENT_MODE" = "false" ] && [ "$SERVER_ONLY" = "false" ] ; then
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
fi

if [ "$INSTALL_CTL" = "true" ] ; then
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
        print_str "Install alias to $PROFILE"
        sed -i '/^alias colinkctl=/d' $PROFILE
        print_str "alias colinkctl=\"$COLINK_HOME/colinkctl\"" >> $PROFILE
        print_str "Reopen your terminal to start using colinkctl."
    else
        print_str "No profile is found, you need to go into $COLINK_HOME to use colinkctl."
    fi
fi

if [ "$SILENT_MODE" = "false" ] ; then
    read -r -p "Start CoLink server now? [Y/n] " response
    case "$response" in
        [nN][oO]|[nN])
            ;;
        *)
            $COLINK_HOME/colinkctl start
            ;;
    esac
fi