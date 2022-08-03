# colinkctl

## Installation
```
bash install_colink.sh
```
```
user@host:~$ bash install_colink.sh 
Install dependencies? [Y/n] 
.....
.....
Install RabbitMQ? [Y/n] 
.....
.....
Installing alias to /home/user/.bashrc
Reopen your terminal to start using colinkctl.
```

## Enable Dev Environment
```
colinkctl enable_dev_env
```
```
user@host:~$ colinkctl enable_dev_env
Do you want to (re)start the colink server? [Y/n] 
Enter the port number for colink server [8080]:
colink server start sucessfully.
host_token: ***
Do you want to create users? [Y/n] 
Enter the number of users you want to create [2]:
.....
.....
Do you want to (re)start the policy module and accept all tasks? [Y/n] 
pid *** started.
pid *** started.
.....
.....
Do you want to (re)start the remote storage? [Y/n] 
pid *** started.
pid *** started.
```
