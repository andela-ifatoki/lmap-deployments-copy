main() {
  # Enable IP Forwarding
  sudo sysctl -w net.ipv4.ip_forward=1

  # Masquerade all egress packages as coming from NAT Gateway
  sudo iptables -t nat -A POSTROUTING -o ens4 -j MASQUERADE
}

main
