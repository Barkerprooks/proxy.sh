# Command Line SOCKS5 SSH Proxy
Just some useful scripts to help me get around things when I need it. For example my job geo-blocks useful resources such as archlinux.org... or alacritty.org. It's interesting how many open source organizations are hosted overseas. Maybe I should join them over there...
## proxy.sh
This is just a simple wrapper for a SOCKS5 `ssh` tunnel. It will log into a host via `ssh` with the `-N` flag. spawn a SOCKS5 tunnel on port `8080` with the `-D 8080` option, and backgrounds the process with the `-f` flag. I have it set up in such a way that one could add a default hostname to the script variables and its just a no-args command. Perhaps in the near future I'll add `env` variable support as well.
```
usage ./proxy.sh -h <hostname> -u <username>

    -h/--host: SSH host to tunnel through
    -u/--user: SSH username for tunnel host (if needed)
```
## update-rc.sh
You just need to run this once and it will be in your `.rc` file forever. This is a nice thing to have for your shell environment because it automatically detects if the SOCKS5 proxy is running and will set the relevant `env` variables without you needing to remember on each shell opened. Important thing to note about this: if you are running something with `sudo` you will need to run commands with the `-E` flag to keep the proxy environment variables from your session. you can uncomment a line of the added `.rc` script in order to alias `sudo` with this so you don't have to remember.
### Affected ENV variables
each environment variable should be set to `socks5://127.0.0.1:8080`, you can check this with `echo $http_proxy`.
- `http_proxy`
- `https_proxy`
- `ftp_proxy`
## System Wide
If your desktop environment is something like `macos` or `gnome` you can use the URI `socks5://127.0.0.1:8080` under your proxy settings in the SOCKS5 category in order to tunnel _some_ of your traffic through the proxy. You can also manually set up the SOCKS5 proxy on most web browsers like `firefox` or `chrome`.
## Installing
Feeling ballsy? go ahead and link the `proxy.sh` script to `/usr/local/bin/proxy.sh` so you can access it from anywhere. Make sure to run `update-rc.sh` beforehand so you get the full package. Make sure you have a final resting place for this repository before running the script below.
```
sudo ln -s $PWD/proxy.sh /usr/local/bin/proxy.sh
```
## Upcoming
- support for environment variables ???
- auto-remove .rc script
## Why are you using this?
If you're on this page you probably already know how to do this stuff. I don't assume anyone will actually use this. I write like it will happen because that way _I_ can look back on this and remember what I was doing.
