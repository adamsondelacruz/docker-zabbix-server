#!/bin/bash
#

set -x

if [[ -n ${SOURCEIP} ]]
    then SOURCE_IP="SourceIP=${SOURCEIP}"
    else SOURCE_IP=""
fi
if [[ -n ${DBSCHEMA} ]]
    then DB_SCHEMA="DBSchema=${DBSCHEMA}"
    else DB_SCHEMA=""
fi
if [[ -n ${DBSOCKET} ]]
    then DB_SOCKET="DBSocket=${DBSOCKET}"
    else DB_SOCKET=""
fi
if [[ -n ${DBPORT} ]]
    then DB_PORT="DBPort=${DBPORT}"
    else DB_PORT=""
fi
if [[ -n ${JAVAGATEWAY} ]]
    then JAVA_GATEWAY="JavaGateway=${JAVAGATEWAY}"
    else JAVA_GATEWAY=""
fi
if [[ -n ${SSHKEYLOCATION} ]]
    then SSH_KEYLOCATION="SSHKeyLocation=${SSHKEYLOCATION}"
    else SSH_KEYLOCATION=""
fi
if [[ -n ${SSLCALOCATION} ]]
    then SSL_CALOCATION="SSLCALocation=${SSLCALOCATION}"
    else SSL_CALOCATION=""
fi
if [[ -n ${LOADMODULE} ]]
    then LOAD_MODULE="LoadModule=${LOADMODULE}"
    else LOAD_MODULE=""
fi
if [[ -n ${TLSCAFILE} ]]
    then TLS_CAFILE="TLSCAFile=${TLSCAFILE}"
    else TLS_CAFILE=""
fi
if [[ -n ${TLSCRLFILE} ]]
    then TLS_CRLFILE="TLSCRLFile=${TLSCRLFILE}"
    else TLS_CRLFILE=""
fi
if [[ -n ${TLSCERTFILE} ]]
    then TLS_CERTFILE="TLSCertFile=${TLSCERTFILE}"
    else TLS_CERTFILE=""
fi
if [[ -n ${TLSKEYFILE} ]]
    then TLS_KEYFILE="TLSKeyFile=${TLSKEYFILE}"
    else TLS_KEYFILE=""
fi

# Print all configuration items with their values
cat <<EOF > /etc/zabbix/zabbix_server.conf
ListenPort=${LISTENPORT:-10051}
${SOURCE_IP}
LogType=${LOGTYPE:-file}
LogFile=${LOGFILE:-/tmp/zabbix_server.log}
LogFileSize=${LOGFILESIZE:-1}
DebugLevel=${DEBUGLEVEL:-3}
PidFile=${PIDFILE:-/tmp/zabbix_server.pid}
DBHost=${DBHOST:-localhost}
DBName=${DBNAME:-zabbix}
${DB_SCHEMA}
DBUser=${DBUSER:-zabbix}
DBPassword=${DBPASSWORD:-zabbix}
${DB_SOCKET}
${DB_PORT}
StartPollers=${STARTPOLLERS:-5}
StartIPMIPollers=${STARTIPMIPOLLERS:-0}
StartPollersUnreachable=${STARTPOLLERSUNREACHABLE:-1}
StartTrappers=${STARTTRAPPERS:-5}
StartPingers=${STARTPINGERS:-1}
StartDiscoverers=${STARTDISCOVERERS:-1}
StartHTTPPollers=${STARTHTTPPOLLERS:-1}
StartTimers=${STARTTIMERS:-1}
StartEscalators=${STARTESCALATORS:-1}
${JAVA_GATEWAY}
JavaGatewayPort=${JAVAGATEWAYPORT:-10052}
StartJavaPollers=${STARTJAVAPOLLERS:-0}
StartVMwareCollectors=${STARTVMWARECOLLECTORS:-0}
VMwareFrequency=${VMWAREFREQUENCY:-60}
VMwarePerfFrequency=${VMWAREPERFFREQUENCY:-60}
VMwareCacheSize=${VMWARECACHESIZE:-8M}
VMwareTimeout=${VMWARETIMEOUT:-10}
SNMPTrapperFile=${SNMPTRAPPERFILE:-/tmp/zabbix_traps.tmp}
StartSNMPTrapper=${STARTSNMPTRAPPER:-0}
ListenIP=${LISTENIP:-0.0.0.0}
HousekeepingFrequency=${HOUSEKEEPINGFREQUENCY:-1}
MaxHousekeeperDelete=${MAXHOUSEKEEPERDELETE:-5000}
SenderFrequency=${SENDERFREQUENCY:-30}
CacheSize=${CACHESIZE:-8M}
CacheUpdateFrequency=${CACHEUPDATEFREQUENCY:-60}
StartDBSyncers=${STARTDBSYNCERS:-4}
HistoryCacheSize=${HISTORYCACHESIZE:-16M}
HistoryIndexCacheSize=${HISTROYINDEXCACHESIZE:-4M}
TrendCacheSize=${TRENDCACHESIZE:-4M}
ValueCacheSize=${VALUECACHESIZE:-8M}
Timeout=${TIMEOUT:-4}
TrapperTimeout=${TRAPPERTIMEOUT:-300}
UnreachablePeriod=${UNREACHABLEPERIOD:-45}
UnavailableDelay=${UNAVAILABLEDELAY:-60}
UnreachableDelay=${UNREACHABLEDELAY:-15}
AlertScriptsPath=${ALERTSCRIPTSPATH:-/var/lib/zabbix/alertscripts}
ExternalScripts=${EXTERNALSCRIPTS:-/var/lib/zabbix/externalscripts}
FpingLocation=${FPINGLOCATION:-/usr/sbin/fping}
${SSH_KEYLOCATION}
LogSlowQueries=${LOGSLOWQUERIES:-3000}
TmpDir=${TMPDIR:-/tmp}
StartProxyPollers=${STARTPROXYPOLLERS:-1}
ProxyConfigFrequency=${PROXYCONFIGFREQUENCY:-3600}
ProxyDataFrequency=${PROXYDATAFREQUENCY:-1}
AllowRoot=${ALLOWROOT:-0}
User=${USER:-zabbix}
Include=${INCLUDE:-/usr/local/etc/zabbix_server.conf.d/}
SSLCertLocation=${SSLCERTLOCATION:-/var/lib/zabbix/ssl/certs}
SSLKeyLocation=${SSLKEYLOCATION:-/var/lib/zabbix/ssl/keys}
${SSL_CALOCATION}
LoadModulePath=${LOADMODULEPATH:-/var/lib/modules}
${LOAD_MODULE}
${TLS_CAFILE}
${TLS_CRLFILE}
${TLS_CERTFILE}
${TLS_KEYFILE}
EOF

echo "Create include dir"
mkdir -p ${INCLUDE:-/usr/local/etc/zabbix_server.conf.d/}

# Check if database is already provisioned
echo "Check if we need to provision database"
ALREADY_EXECUTED=$(mysql -h ${DBHOST} -u ${DBUSER} -p"${DBPASSWORD}" -D "${DBNAME}" -Ne 'select userid from users where alias = "Admin";' | wc -l)

if [[ ${ALREADY_EXECUTED} -eq 0 ]]
    then
        echo "Provision database"
        cd /opt/zabbix/database

        for sqlfile in `ls -1 *.sql`; do
            echo "Provision with file ${sqlfile}"
            mysql -h "${DBHOST}" -u "${DBUSER}" -p"${DBPASSWORD}" -D "${DBNAME}" < ${sqlfile}
        done
fi

# Start Zabbix Server
echo "Startig Zabbix"
echo "sudo -u zabbix /usr/local/sbin/zabbix_server -c /etc/zabbix/zabbix_server.conf"
sudo -u zabbix /usr/local/sbin/zabbix_server -fc /etc/zabbix/zabbix_server.conf
