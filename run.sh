#!/usr/bin/env sh

# Generate random 8 symbols password
_randPass() {
    head -c 8 /dev/urandom | xxd -p
}

# Create specified users or a test user
_credCreate() {
    rm -f /etc/3proxy/credentials.conf
    if [ -z "${PROXY_SECRET}" ]; then
        randpass=$(_randPass)
        echo "users user:CL:${randpass}" > /etc/3proxy/credentials.conf
        echo -e "\nWarning: PROXY_SECRET variable is not specified! Using random password:\nlogin: user\npass: ${randpass}\n"
    else
        num=`echo ${PROXY_SECRET} | sed 's/,/\n/g' | wc -l`
        for n in $(seq ${num}); do
            user=`echo ${PROXY_SECRET} | sed 's/,/\n/g' | sed -n ${n}p | cut -d: -f1`
            pass=`echo ${PROXY_SECRET} | sed 's/,/\n/g' | sed -n ${n}p | cut -d: -f2`
            echo "users ${user}:CL:${pass}" >> /etc/3proxy/credentials.conf
        done
    fi
#echo "setuid $(id -u nobody)" >> /etc/3proxy/credentials.conf
echo "setgid $(id -g nobody)" >> /etc/3proxy/credentials.conf
}

# Starting 3proxy
_start3proxy() {
    if (pgrep -fl 3proxy >/dev/null 2>&1); then
        echo "Info: 3proxy process already running, killing..."
        pkill -9 3proxy
    fi
    3proxy /etc/3proxy/3proxy.conf &
    sleep 1
    pkill -USR1 3proxy
    echo "Info: 3proxy process started!"
}

# Checking process is running
_healthCheck() {
    while (pgrep -fl 3proxy >/dev/null 2>&1)
    do
        sleep 5
    done
    echo "Error: 3proxy is not running, exiting..."
    exit 1
}

_credCreate
_start3proxy
_healthCheck