iptables -t nat -F SHADOWSOCKS
iptables -t nat -X SHADOWSOCKS

# Create new chain
iptables -t nat -N SHADOWSOCKS

# Ignore shadowsocks server's addresses
# it's very significant to avoid loop
iptables -t nat -A SHADOWSOCKS -d $1 -j RETURN

# Ignore LANs addresses to bypass the proxy
# See Wikipedia and RFC5735 for full list of reserved networks

iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 10.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 127.0.0.0/8 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 169.254.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 172.16.0.0/12 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 192.168.0.0/16 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 224.0.0.0/4 -j RETURN
iptables -t nat -A SHADOWSOCKS -d 240.0.0.0/4 -j RETURN

#Anything else should be redirected to shadowsocks's local port
iptables -t nat -A SHADOWSOCKS -p tcp -j REDIRECT --to-ports 1080

# Apply the rules
iptables -t nat -A OUTPUT -p tcp -j SHADOWSOCKS

# Start the shadowsocks-redir
sudo ss-redir -s $1 -p $2  -l 1080 -k $3 -m $4 -v
