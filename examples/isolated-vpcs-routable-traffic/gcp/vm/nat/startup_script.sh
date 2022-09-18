#! /bin/bash
apt-get update
apt-get install dnsutils -y
echo 1 >/proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
eth0_ip="$(curl -H "Metadata-Flavor:Google" \
  http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/ip)"
google_dns1="$(dig +short dns.google | head -n 1)"
google_dns2="$(dig +short dns.google | tail -n 1)"
sudo iptables -t nat -A PREROUTING -p tcp -s 35.191.0.0/16 \
  -d $eth0_ip --dport 443 -j DNAT --to $google_dns1
sudo iptables -t nat -A PREROUTING -p tcp -s 130.211.0.0/22 \
  -d $eth0_ip --dport 443 -j DNAT --to $google_dns2
