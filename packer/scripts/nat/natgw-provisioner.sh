#/bin/bash -e

main() {
  # Enable IP Forwarding
  sudo mv /tmp/sysctl.conf /etc/sysctl.conf
  # Masquerade all egress packages as coming from NAT Gateway
  sudo iptables -t nat -A POSTROUTING -o ens4 -j MASQUERADE
}

main
