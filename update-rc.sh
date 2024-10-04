#!/bin/bash

function echo_rc_script() {
	echo
	echo "# checks to see if an ssh socks5 proxy is running, if so, sets the proper ENV variables"
	echo "# NOTE: when using sudo, make sure to use -E so these variables are preserved"
	echo "# NOTE: do NOT remove these comments unless you are removing the code below"
	echo "proxy_pid=\$(ps aux | grep 'ssh -D 8080' | grep -v grep | head -n 1 | awk '{print \$2}')"
	echo "if ! [ -z \"\${proxy_pid}\" ]; then"
	echo "	proxy_url='socks5://127.0.0.1:8080'"
	echo "	export http_proxy=\$proxy_url https_proxy=\$proxy_url ftp_proxy=\$proxy_url"
	echo "	# uncomment the line below if you want sudo to be aliased"
	echo "	# alias sudo='sudo -E'"
	echo "	# uncomment the line below if you would like the shell to alert you on startup"
	echo "	# echo '[!] socks5 proxy is active'"
	echo "fi"
	echo
}

supported=("sh" "bash" "zsh")
shell=$(echo $SHELL | rev | cut -f 1 -d / | rev)
regex="\<${shell}\>"

echo "[!] shell = $shell"
if [[ ${supported[@]} =~ $regex ]]; then
	rcfile="$HOME/.${shell}rc"
	echo "[!] .rc file = $rcfile"
	if ! [ -f $rcfile ]; then touch $rcfile; fi
	if ! [ -z "$(cat $rcfile | grep '# NOTE: do NOT remove these comments')" ]; then
		echo "[!] .rc file appears to already be set up."
		echo "[!] nothing was done."
	else
		echo_rc_script >> $rcfile
		echo "[+] .rc script successfully added! It will become effective next time you open a terminal window."
	fi
else
	echo "[!] not supported, you need to manually add the analouge of the script below to your"
	echo "    unsupported shell's .rc file:"
	echo_rc_script
fi
