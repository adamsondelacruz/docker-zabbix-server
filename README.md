# docker-zabbix-server


# Introduction

This docker container only contains an Zabbix server which is configured to use an MySQL database, but doesn't have an database server in the container. When using this container, you'll need to have already have an MySQL database running. Either in an docker container or somewhere on an server.
Also this container has no zabbix-web configured, so you'll have to `wdijkerman/zabbix-web` or use an other container.

## Versions

- `0.0.1`, `latest` [(Dockerfile)](https://github.com/dj-wasabi/docker-zabbix-server/blob/master/Dockerfile)

# Install the container

Just run the following command to download the container:

```bash
docker pull wdijkerman/zabbix-server
```

# Using the container

Basic usage of the container:

```bash
docker run  -p 10051:10051 --name zabbix-server \
            -e DBHOST=192.168.1.153 -e DBUSER=zabbix \
            -e DBPASSWORD="zabbix-pass" \
            -e DBPORT=3306 -e DBNAME=zabbix wdijkerman/zabbix-server
```

You'll have to pass environment parameters to the container. 

| Variable   | Description|
| -----------|-------------|
| DBHOST     | The host on which the database is running. |
| DBUSER     | The username to use for accassing the MySQL database|
| DBPASSWORD | The password for the DBUSER. |
| DBPORT     | The port on which MySQL is running. Default: 3306 |
| DBNAME     | The name of the database. Default: zabbix|

# License

The MIT License (MIT)

See file: License

# Issues

Please report issues at https://github.com/dj-wasabi/docker-zabbix-server/issues 

Pull Requests are welcome!