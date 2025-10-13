#!/bin/bash
# ==========================================
# Soal_5.sh
# Konfigurasi hostname, hosts, dan resolver
# untuk seluruh node jaringan K31
# ==========================================

# EONWE
if [ "$(hostname)" = "eonwe" ]; then
echo "eonwe" > /etc/hostname
hostname eonwe

cat > /etc/hosts <<'EOF'
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback

10.79.1.1       eonwe.k31.com      eonwe
10.79.1.2       earendil.k31.com   earendil
10.79.1.3       elwing.k31.com     elwing

10.79.2.2       cirdan.k31.com     cirdan
10.79.2.3       elrond.k31.com     elrond
10.79.2.4       maglor.k31.com     maglor

10.79.3.2       sirion.k31.com     sirion
10.79.3.3       tirion.k31.com     tirion
10.79.3.4       valmar.k31.com     valmar
10.79.3.5       lindon.k31.com     lindon
10.79.3.6       vingilot.k31.com   vingilot
EOF

echo "nameserver 192.168.122.1" > /etc/resolv.conf
fi


# EARENDIL
if [ "$(hostname)" = "earendil" ]; then
echo "earendil" > /etc/hostname
hostname earendil

cat > /etc/hosts <<'EOF'
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback

10.79.1.1       eonwe.k31.com      eonwe
10.79.1.2       earendil.k31.com   earendil
10.79.1.3       elwing.k31.com     elwing

10.79.2.2       cirdan.k31.com     cirdan
10.79.2.3       elrond.k31.com     elrond
10.79.2.4       maglor.k31.com     maglor

10.79.3.2       sirion.k31.com     sirion
10.79.3.3       tirion.k31.com     tirion
10.79.3.4       valmar.k31.com     valmar
10.79.3.5       lindon.k31.com     lindon
10.79.3.6       vingilot.k31.com   vingilot
EOF

echo "nameserver 10.79.3.3" > /etc/resolv.conf
echo "nameserver 10.79.3.4" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf
fi


# ELWING
if [ "$(hostname)" = "elwing" ]; then
echo "elwing" > /etc/hostname
hostname elwing

cat > /etc/hosts <<'EOF'
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback

10.79.1.1       eonwe.k31.com      eonwe
10.79.1.2       earendil.k31.com   earendil
10.79.1.3       elwing.k31.com     elwing

10.79.2.2       cirdan.k31.com     cirdan
10.79.2.3       elrond.k31.com     elrond
10.79.2.4       maglor.k31.com     maglor

10.79.3.2       sirion.k31.com     sirion
10.79.3.3       tirion.k31.com     tirion
10.79.3.4       valmar.k31.com     valmar
10.79.3.5       lindon.k31.com     lindon
10.79.3.6       vingilot.k31.com   vingilot
EOF

echo "nameserver 10.79.3.3" > /etc/resolv.conf
echo "nameserver 10.79.3.4" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf
fi


# CIRDAN
if [ "$(hostname)" = "cirdan" ]; then
echo "cirdan" > /etc/hostname
hostname cirdan

cat > /etc/hosts <<'EOF'
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback

10.79.1.1       eonwe.k31.com      eonwe
10.79.1.2       earendil.k31.com   earendil
10.79.1.3       elwing.k31.com     elwing

10.79.2.2       cirdan.k31.com     cirdan
10.79.2.3       elrond.k31.com     elrond
10.79.2.4       maglor.k31.com     maglor

10.79.3.2       sirion.k31.com     sirion
10.79.3.3       tirion.k31.com     tirion
10.79.3.4       valmar.k31.com     valmar
10.79.3.5       lindon.k31.com     lindon
10.79.3.6       vingilot.k31.com   vingilot
EOF

echo "nameserver 10.79.3.3" > /etc/resolv.conf
echo "nameserver 10.79.3.4" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf
fi


# ELROND
if [ "$(hostname)" = "elrond" ]; then
echo "elrond" > /etc/hostname
hostname elrond

cat > /etc/hosts <<'EOF'
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback

10.79.1.1       eonwe.k31.com      eonwe
10.79.1.2       earendil.k31.com   earendil
10.79.1.3       elwing.k31.com     elwing

10.79.2.2       cirdan.k31.com     cirdan
10.79.2.3       elrond.k31.com     elrond
10.79.2.4       maglor.k31.com     maglor

10.79.3.2       sirion.k31.com     sirion
10.79.3.3       tirion.k31.com     tirion
10.79.3.4       valmar.k31.com     valmar
10.79.3.5       lindon.k31.com     lindon
10.79.3.6       vingilot.k31.com   vingilot
EOF

echo "nameserver 10.79.3.3" > /etc/resolv.conf
echo "nameserver 10.79.3.4" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf
fi


# MAGLOR
if [ "$(hostname)" = "maglor" ]; then
echo "maglor" > /etc/hostname
hostname maglor

cat > /etc/hosts <<'EOF'
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback

10.79.1.1       eonwe.k31.com      eonwe
10.79.1.2       earendil.k31.com   earendil
10.79.1.3       elwing.k31.com     elwing

10.79.2.2       cirdan.k31.com     cirdan
10.79.2.3       elrond.k31.com     elrond
10.79.2.4       maglor.k31.com     maglor

10.79.3.2       sirion.k31.com     sirion
10.79.3.3       tirion.k31.com     tirion
10.79.3.4       valmar.k31.com     valmar
10.79.3.5       lindon.k31.com     lindon
10.79.3.6       vingilot.k31.com   vingilot
EOF

echo "nameserver 10.79.3.3" > /etc/resolv.conf
echo "nameserver 10.79.3.4" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf
fi


# SIRION
if [ "$(hostname)" = "sirion" ]; then
echo "sirion" > /etc/hostname
hostname sirion

cat > /etc/hosts <<'EOF'
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback

10.79.1.1       eonwe.k31.com      eonwe
10.79.1.2       earendil.k31.com   earendil
10.79.1.3       elwing.k31.com     elwing

10.79.2.2       cirdan.k31.com     cirdan
10.79.2.3       elrond.k31.com     elrond
10.79.2.4       maglor.k31.com     maglor

10.79.3.2       sirion.k31.com     sirion
10.79.3.3       tirion.k31.com     tirion
10.79.3.4       valmar.k31.com     valmar
10.79.3.5       lindon.k31.com     lindon
10.79.3.6       vingilot.k31.com   vingilot
EOF

echo "nameserver 10.79.3.3" > /etc/resolv.conf
echo "nameserver 10.79.3.4" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf
fi


# TIRION (DNS Master)
if [ "$(hostname)" = "tirion" ]; then
echo "tirion" > /etc/hostname
hostname tirion

cat > /etc/hosts <<'EOF'
127.0.0.1   localhost
10.79.3.3   tirion.k31.com   tirion
EOF

apt update && apt install -y bind9
systemctl enable bind9
systemctl restart bind9
fi


# VALMAR (DNS Slave)
if [ "$(hostname)" = "valmar" ]; then
echo "valmar" > /etc/hostname
hostname valmar

cat > /etc/hosts <<'EOF'
127.0.0.1   localhost
10.79.3.4   valmar.k31.com   valmar
EOF

apt update && apt install -y bind9
systemctl enable bind9
systemctl restart bind9
fi


# LINDON
if [ "$(hostname)" = "lindon" ]; then
echo "lindon" > /etc/hostname
hostname lindon

cat > /etc/hosts <<'EOF'
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback

10.79.1.1       eonwe.k31.com      eonwe
10.79.1.2       earendil.k31.com   earendil
10.79.1.3       elwing.k31.com     elwing

10.79.2.2       cirdan.k31.com     cirdan
10.79.2.3       elrond.k31.com     elrond
10.79.2.4       maglor.k31.com     maglor

10.79.3.2       sirion.k31.com     sirion
10.79.3.3       tirion.k31.com     tirion
10.79.3.4       valmar.k31.com     valmar
10.79.3.5       lindon.k31.com     lindon
10.79.3.6       vingilot.k31.com   vingilot
EOF

echo "nameserver 10.79.3.3" > /etc/resolv.conf
echo "nameserver 10.79.3.4" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf
fi


# VINGILOT
if [ "$(hostname)" = "vingilot" ]; then
echo "vingilot" > /etc/hostname
hostname vingilot

cat > /etc/hosts <<'EOF'
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback

10.79.1.1       eonwe.k31.com      eonwe
10.79.1.2       earendil.k31.com   earendil
10.79.1.3       elwing.k31.com     elwing

10.79.2.2       cirdan.k31.com     cirdan
10.79.2.3       elrond.k31.com     elrond
10.79.2.4       maglor.k31.com     maglor

10.79.3.2       sirion.k31.com     sirion
10.79.3.3       tirion.k31.com     tirion
10.79.3.4       valmar.k31.com     valmar
10.79.3.5       lindon.k31.com     lindon
10.79.3.6       vingilot.k31.com   vingilot
EOF

echo "nameserver 10.79.3.3" > /etc/resolv.conf
echo "nameserver 10.79.3.4" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf
fi

echo "Konfigurasi Soal_5.sh selesai untuk host $(hostname)"
