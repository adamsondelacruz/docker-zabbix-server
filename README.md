# docker-zabbix-server


# Introduction

This docker container only contains an Zabbix server which is configured to use an MySQL database, but doesn't have an database server in the container. When using this container, you'll need to have already have an MySQL database running. Either in an docker container or somewhere on an server.
Also this container has no zabbix-web configured, so you'll have to `wdijkerman/zabbix-web` or use an other container.

## Prerequisites

An MySQL server should be present. When the `ROOTPASSWORD` variable is set, it will create the database and create the user `DBUSER`.

## Versions

### Dockerfile
- `0.0.1`, `latest` [(Dockerfile)](https://github.com/dj-wasabi/docker-zabbix-server/blob/master/Dockerfile)

### Zabbix

Current version: 3.0.1

# Install the container

Just run the following command to download the container:

```bash
docker pull wdijkerman/zabbix-server
```

# Using the container

Basic usage of the container:

```bash
docker run  -p 10051:10051 --name zabbix-server \
            -e ROOTPASSWORD=secretpassword \
            -e DBHOST=192.168.1.153 -e DBUSER=zabbix \
            -e DBPASSWORD="zabbix-pass" \
            -e DBPORT=3306 -e DBNAME=zabbix wdijkerman/zabbix-server
```

You'll have to pass environment parameters to the container. 

| Variable     | Description|
| -------------|-------------|
| ROOTPASSWORD | The password for the ROOT user in MySQL. |
| DBHOST       | The host on which the database is running. |
| DBUSER       | The username to use for accessing the MySQL database|
| DBPASSWORD   | The password for the DBUSER. |
| DBPORT       | The port on which MySQL is running. Default: 3306 |
| DBNAME       | The name of the database. Default: zabbix|

When `ROOTPASSWORD` is not supplied, the database specific with `DBNAME` and the user `DBUSER` should already be available.

# Volumes

There is one volume configured:

```
/zabbix
```

Example:
```bash
docker run  -p 10051:10051 --name zabbix-server \
            -v /data/zabbix:/zabbix \
            -e ROOTPASSWORD=secretpassword \
            -e DBHOST=192.168.1.153 -e DBUSER=zabbix \
            -e DBPASSWORD="zabbix-pass" \
            -e DBPORT=3306 -e DBNAME=zabbix wdijkerman/zabbix-server
```

This volume contains the following directories when the container is started:
```
alertscripts
externalscripts
modules
serverconfd
ssl
```

Explanation of directories:

| Directory       | Purpose|
| ----------------|-------------|
| alertscripts    | Directory for the alert scripts. (`AlertScriptsPath` parameter)|
| externalscripts | Directory containing the external scripts. (`ExternalScripts` parameter)|
| modules         | Directory where modules can be stored/placed. (`LoadModulePath` parameter |
| serverconfd     | Directory where configuration can be placed (`Include` parameter) |
| ssl             | Directory for SSL files. (`SSLCertLocation` and/or `SSLKeyLocation` or other ssl configuration parameters|


# License

The MIT License (MIT)

See file: License

# Issues

Please report issues at https://github.com/dj-wasabi/docker-zabbix-server/issues 

Pull Requests are welcome!
