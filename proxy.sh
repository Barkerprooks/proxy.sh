#!/bin/bash

function check_process() {
	local pid=$(ps aux | grep 'ssh -D 8080' | grep -v grep | head -n 1 | awk '{print $2}')
	echo $pid
}

proxy_url='socks5://127.0.0.1:8080' # this shouldnt change
proxy_host='' # set hostname to tunnel through
proxy_user='' # set username if needed (if the server username differs from client)

# process the command line args if they are there
while [[ "$#" -gt 0 ]]; do
	case $1 in
		-h|--host) proxy_host=$2; shift ;;
		-u|--user) proxy_user=$2; shift ;;
	esac
	shift
done

# if hostname is still blank give the help page
if [ -z "${proxy_host}" ]; then
	echo "usage $0 -h <hostname> -u <username>"
	echo
	echo "    -h/--host: SSH host to tunnel through"
	echo "    -u/--user: SSH username for tunnel host (if needed)"
	echo 
	exit 0
fi

# first, check to see if the proxy is alive. if so, we are just going to kill it.
# sorry.
proxy_pid=$(check_process)
if ! [ -z "${proxy_pid}" ]; then
	echo "found active proxy." 
	echo "killing..."
	kill -9 $proxy_pid
	echo "you can restart by re-running the script."
	exit 0
fi

# build the hostname. if a user is supplied its: <user>@<host>.
if ! [ -z "${proxy_user}" ]; then proxy_host="$proxy_user@$proxy_host"; fi

# SSH will prompt you to log in if you havent set up keys
# harsh timeout because if it takes that long there's no point in using it as
# a proxy
# DO NOT CHANGE "ssh -D 8080"
# JUST APPEND TO IT, WE LOOK IN THE PROCESS LIST FOR THIS SUBSTRING
ssh -D 8080 -o ConnectTimeout=5 -Nf $proxy_host

# if there's an error logging in it will bubble up here

proxy_pid=$(check_process)
if ! [ -z "${proxy_pid}" ]; then
	export http_proxy=$proxy_url https_proxy=$proxy_url ftp_proxy=$proxy_url
	echo '[!] socks5 proxy is now active'
fi
