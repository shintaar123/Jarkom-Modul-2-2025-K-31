# Jarkom-Modul-1-2025-K-31

## Angggota

| Anggota | NRP  |
| ------- | --- |
| Shinta Alya Ramadani | 5027241016 |
| Rayhan Agnan Kusuma | 5027241102 |

## Prefix IP yang digunakan untuk kelompok K-31

| Nama Kelompok   | Prefix IP |
| ----------- | --------- | 
| K-31         |      10.79   | 


## Nomor 1
<img width="926" height="718" alt="image" src="https://github.com/user-attachments/assets/a13f7bd8-96ce-4eaf-8956-78f1a05c2211" />

#### Soal
Di tepi Beleriand yang porak-poranda, Eonwe merentangkan tiga jalur: Barat untuk Earendil dan Elwing, Timur untuk Círdan, Elrond, Maglor, serta pelabuhan DMZ bagi Sirion, Tirion, Valmar, Lindon, Vingilot. Tetapkan alamat dan default gateway tiap tokoh sesuai glosarium yang sudah diberikan.
#### Tujuan
Menentukan konfigurasi alamat IP dan gateway untuk seluruh node agar setiap host dapat saling terhubung melalui router Eonwe.
#### Step by Step
```
- EONWE CONFIG -
auto eth0
iface eth0 inet dhcp
auto eth1
iface eth1 inet static
	address 10.79.1.1
	netmask 255.255.255.0
auto eth2
iface eth2 inet static
	address 10.79.2.1
	netmask 255.255.255.0
auto eth3
iface eth3 inet static
	address 10.79.3.1
	netmask 255.255.255.0

- EARENDIL -
auto eth0
iface eth0 inet static
	address 10.79.1.2
	netmask 255.255.255.0
	gateway 10.79.1.1

- ELWING -
auto eth0
iface eth0 inet static
	address 10.79.1.3
	netmask 255.255.255.0
	gateway 10.79.1.1

- CIRDAN -
auto eth0
iface eth0 inet static
	address 10.79.2.2
	netmask 255.255.255.0
	gateway 10.79.2.1

- ELROND -
auto eth0
iface eth0 inet static
	address 10.79.2.3
	netmask 255.255.255.0
	gateway 10.79.2.1

- MAGLOR -
auto eth0
iface eth0 inet static
	address 10.79.2.4
	netmask 255.255.255.0
	gateway 10.79.2.1

- SIRION -
auto eth0
iface eth0 inet static
	address 10.79.3.2
	netmask 255.255.255.0
	gateway 10.79.3.1

- TIRION -
auto eth0
iface eth0 inet static
	address 10.79.3.3
	netmask 255.255.255.0
	gateway 10.79.3.1

- VALMAR -
auto eth0
iface eth0 inet static
	address 10.79.3.4
	netmask 255.255.255.0
	gateway 10.79.3.1

- LINDON -
auto eth0
iface eth0 inet static
	address 10.79.3.5
	netmask 255.255.255.0
	gateway 10.79.3.1

- VINGILOT -
auto eth0
iface eth0 inet static
	address 10.79.3.6
	netmask 255.255.255.0
	gateway 10.79.3.1
```
```
# Uji koneksi antar host
ping -c 3 192.168.1.1
ping -c 3 192.168.2.1
ping -c 3 192.168.3.1
```

## Nomor 2
#### Soal
Angin dari luar mulai berhembus ketika Eonwe membuka jalan ke awan NAT. Pastikan jalur WAN di router aktif dan NAT meneruskan trafik keluar bagi seluruh alamat internal sehingga host di dalam dapat mencapai layanan di luar menggunakan IP address.
#### Tujuan
Mengaktifkan NAT di router agar seluruh host internal dapat mengakses jaringan eksternal (internet).
#### Step by Step
```
# Instalasi iptables
apt update && apt install -y iptables
```
```
**DI EONWE**
nano /root/.bashrc
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.79.0.0/16
echo nameserver 192.168.122.1 > /etc/resolv.conf
ping google.com -c 2
```
set permanen di dalam nano /root/.bashrc
<img width="816" height="440" alt="image" src="https://github.com/user-attachments/assets/ee2e3def-e8cc-4f5a-8ab2-0b2a5cb8e388" />

## Nomor 3
#### Soal
Kabar dari Barat menyapa Timur. Pastikan kelima klien dapat saling berkomunikasi lintas jalur (routing internal via Eonwe berfungsi), lalu pastikan setiap host non-router menambahkan resolver 192.168.122.1 saat interfacenya aktif agar akses paket dari internet tersedia sejak awal.
#### Tujuan
Memastikan routing antar subnet berjalan dan semua klien dapat menggunakan DNS eksternal untuk mengunduh paket internet.
#### Step by Step
```
# Tambahkan resolver eksternal di semua host non-router
echo nameserver 192.168.122.1 > /etc/resolv.conf
ping google.com -c 2
```

## Nomor 4
#### Soal
Para penjaga nama naik ke menara, di Tirion (ns1/master) bangun zona k31.com sebagai authoritative dengan SOA yang menunjuk ke ns1.k31.com dan catatan NS untuk ns1.k31.com dan ns2.k31.com. Buat A record untuk ns1.k31.com dan ns2.k31.com yang mengarah ke alamat Tirion dan Valmar sesuai glosarium, serta A record apex k31.com yang mengarah ke alamat Sirion (front door), aktifkan notify dan allow-transfer ke Valmar, set forwarders ke 192.168.122.1. Di Valmar (ns2/slave) tarik zona k31.com dari Tirion dan pastikan menjawab authoritative.
Pada seluruh host non-router ubah urutan resolver menjadi ns1.k31.com → ns2.k31.com → 192.168.122.1. Verifikasi query ke apex dan hostname layanan dalam zona dijawab melalui ns1/ns2.
#### Tujuan
Membangun DNS master–slave untuk domain k31.com agar semua host dapat resolve domain secara internal.
#### Step by Step
**DI TIRION**
```
apt update && apt install bind9 -y
mkdir -p /etc/bind/zones
nano /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    dnssec-validation auto;
    listen-on { any; };
    listen-on-v6 { any; };
};

nano /etc/bind/named.conf.local
zone "k31.com" {
    type master;
    file "/etc/bind/zones/db.k31.com";
    notify yes;
    allow-transfer { 10.79.3.4; }; // Valmar (ns2)
};

nano /etc/bind/zones/db.k31.com
$TTL 604800
@   IN  SOA ns1.k31.com. admin.k31.com. (
        2025101101 ; Serial
        3600       ; Refresh
        1800       ; Retry
        604800     ; Expire
        30         ; Minimum TTL
)
; --- NS Record ---
    IN  NS  ns1.k31.com.
    IN  NS  ns2.k31.com.

; --- A Record ---
ns1     IN  A   10.79.3.3      ; Tirion (master)
ns2     IN  A   10.79.3.4      ; Valmar (slave)
@       IN  A   10.79.3.2      ; Sirion (front door)

; --- Hostname Records ---
sirion  IN  A   10.79.3.2
lindon  IN  A   10.79.3.5
vingilot IN A   10.79.3.6

; --- CNAME (alias) ---
www     IN  CNAME sirion
static  IN  CNAME lindon
app     IN  CNAME vingilot
```
```
// cek kofigurasi
named-checkconf
named-checkzone k31.com /etc/bind/zones/db.k31.com

// jalankan bin9
/usr/sbin/named -c /etc/bind/named.conf -f -u bind &

// cek apakah jalan
ps aux | grep named
```
**DI VALMAR**
```
apt update && apt install bind9 -y
mkdir -p /var/cache/bind
nano /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";

    forwarders {
        192.168.122.1;
    };

    dnssec-validation auto;
    listen-on { any; };
    listen-on-v6 { any; };
};

nano /etc/bind/named.conf.local
zone "k31.com" {
    type slave;
    file "/var/cache/bind/db.k31.com";
    masters { 10.79.3.3; }; // Tirion (master)
};
```
```
// jalankan manual
/usr/sbin/named -c /etc/bind/named.conf -f -u bind &

// cek apakan zone transfer berhasil
ls /var/cache/bind/

// tes dari valmar
dig @10.79.3.4 k31.com
```
**DI SEMUA NODE HOST NON ROUTER**
```
echo "nameserver 10.79.3.3" > /etc/resolv.conf
echo "nameserver 10.79.3.4" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf
cat /etc/resolv.conf

dig k31.com
dig ns1.k31.com
dig sirion.k31.com
dig www.k31.com
```
<img width="1163" height="423" alt="image" src="https://github.com/user-attachments/assets/5c136cf8-3165-4064-b95d-6db3013f6379" />

<img width="811" height="486" alt="image" src="https://github.com/user-attachments/assets/52aedda3-57c2-4fc5-97f6-3c732d633837" />


## Nomor 5
#### Soal
“Nama memberi arah,” kata Eonwe. Namai semua tokoh (hostname) sesuai glosarium: eonwe, earendil, elwing, cirdan, elrond, maglor, sirion, tirion, valmar, lindon, vingilot. Verifikasi bahwa setiap host mengenali dan menggunakan hostname tersebut secara system-wide. Buat setiap domain untuk masing-masing node sesuai namanya (contoh: eru.k31.com) dan assign IP masing-masing juga. Lakukan pengecualian untuk node yang bertanggung jawab atas ns1 dan ns2.
#### Tujuan
Menetapkan hostname dan domain untuk setiap node agar dapat dikenali melalui DNS internal.
#### Step by Step
EONWE
```
// set hostname
echo "eonwe" > /etc/hostname
hostname eonwe

// update /etc/hosts (full list karena router)
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

// set resolver (router boleh tetap pakai upstream)
echo "nameserver 192.168.122.1" > /etc/resolv.conf

// verify
hostname
cat /etc/hostname
cat /etc/hosts
cat /etc/resolv.conf
```
EARENDIL
```
// set hostname

// write /etc/hosts (full list — karena ini client non-DNS)
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

// set resolver priority: Tirion -> Valmar -> upstream
echo "nameserver 10.79.3.3" > /etc/resolv.conf
echo "nameserver 10.79.3.4" >> /etc/resolv.conf
echo "nameserver 192.168.122.1" >> /etc/resolv.conf

// verify
hostname
cat /etc/hostname
cat /etc/hosts
cat /etc/resolv.conf
```
ELWING
```
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

hostname
cat /etc/hostname
```
CIRDAN
```
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

hostname
cat /etc/hostname
```
ELROND
```
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

hostname
cat /etc/hostname
```
MAGLOR
```
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

hostname
cat /etc/hostname
```
SIRION
```
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

hostname
cat /etc/hostname
```
TIRION
```
echo "tirion" > /etc/hostname
hostname tirion

// Minimal hosts only (agar DNS master diuji, jangan masukkan semua hosts)
cat > /etc/hosts <<'EOF'
127.0.0.1   localhost
10.79.3.3   tirion.k31.com   tirion
EOF

// Ensure bind9 is running (jika belum)
// kamu sebelumnya install & start bind9 in No.4; kalau belum:
// apt update && apt install bind9 -y
// /usr/sbin/named -c /etc/bind/named.conf -f -u bind &

// verify
hostname
cat /etc/hostname
cat /etc/hosts
```
VALMAR
```
echo "valmar" > /etc/hostname
hostname valmar

cat > /etc/hosts <<'EOF'
127.0.0.1   localhost
10.79.3.4   valmar.k31.com   valmar
EOF

// Make sure bind9 is installed and slave zone pulled (you did earlier)
// verify hosts
hostname
cat /etc/hosts
```
LINDON
```
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

hostname
cat /etc/hostname
```
VINGILOT
```
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

hostname
cat /etc/hostname
```
Setelah semua node di-set — Verifikasi dari Earendil (atau client mana saja)
Jalankan ini di console earendil (copy-paste semua):
```
// cek FQDN lokal
hostname
cat /etc/hostname
hostname -f || true   # jika hostname -f tidak tersedia, skip

// test lookup via getent (pakai NSS)
getent hosts eonwe.k31.com
getent hosts tirion.k31.com
getent hosts valmar.k31.com
getent hosts sirion.k31.com

// test dig (DNS harus jawab via Tirion/Valmar)
dig k31.com
dig sirion.k31.com
dig www.k31.com

// ping pake FQDN
for h in eonwe earendil elwing cirdan elrond maglor sirion tirion valmar lindon vingilot; do
  echo ">>> ping $h.k31.com"
  ping -c 1 $h.k31.com || echo "GAGAL: $h.k31.com"
done
```
Yang harus muncul:
- getent hosts <host> → mengembalikan IP sesuai /etc/hosts atau DNS jika tidak di /etc/hosts (Tirion/Valmar minimal tapi DNS master/slave akan jawab).
<img width="482" height="209" alt="image" src="https://github.com/user-attachments/assets/d3cde099-7657-425b-861a-8225cd99d725" />

- dig k31.com → ANSWER SECTION berisi 10.79.3.2 (sirion) dan SERVER: menunjukkan 10.79.3.3 (tirion) atau 10.79.3.4 (valmar).
<img width="725" height="484" alt="image" src="https://github.com/user-attachments/assets/a9ba205d-c09e-49d1-a929-316809617b56" />

- Semua ping harus reply kecuali ada masalah network/topology di GNS3.

## Nomor 6
#### Soal
Lonceng Valmar berdentang mengikuti irama Tirion. Pastikan zone transfer berjalan, pastikan Valmar (ns2) telah menerima salinan zona terbaru dari Tirion (ns1). Nilai serial SOA di keduanya harus sama.
#### Tujuan
Memastikan mekanisme sinkronisasi zona DNS antara master (Tirion) dan slave (Valmar) berjalan otomatis.
#### Step by Step
1. Konfigurasi Master (Tirion/ns1)
```
nano /etc/bind/named.conf.local
zone "k31.com" {
    type master;
    file "/etc/bind/zones/db.k31.com";
    notify yes;
    allow-transfer { 10.79.3.4; }; // Valmar (ns2)
};
Cek file zona:
cat /etc/bind/zones/db.k31.com
Pastikan ada:
 $TTL 604800
@ IN SOA ns1.k31.com. admin.k31.com. (
    2025101101 ; Serial
    3600 1800 604800 30
)
    IN NS ns1.k31.com.
    IN NS ns2.k31.com.
Validasi & restart:
named-checkconf
named-checkzone k31.com /etc/bind/zones/db.k31.com
/usr/sbin/named -c /etc/bind/named.conf -f -u bind &
```
2. Konfigurasi Slave (Valmar/ns2)
```
nano /etc/bind/named.conf.local

 zone "k31.com" {
    type slave;
    file "/var/cache/bind/db.k31.com";
    masters { 10.79.3.3; }; // Tirion
};
Jalankan ulang bind9:
/usr/sbin/named -c /etc/bind/named.conf -f -u bind &
```
3. Cek Zone Transfer
```
Di Valmar:
 ls -l /var/cache/bind/
 Harus ada file db.k31.com
File tampil aneh (simbol acak) = normal, karena disimpan dalam format biner.
```
4. Bandingkan Serial SOA
```
Di Tirion:
dig @10.79.3.3 k31.com SOA
Di Valmar:
dig @10.79.3.4 k31.com SOA
```
Nomor serial harus sama di keduanya → zone transfer berhasil ✅

5. Uji Transfer Otomatis (Opsional)
```
Ubah file zona di Tirion, tambahkan: nano /etc/bind/zones/db.k31.com
test IN A 10.79.3.10
dan naikkan serial jadi 2025101201.
```
Restart bind9 Tirion:
```
/usr/sbin/named -c /etc/bind/named.conf -f -u bind &
Di Valmar, cek:
dig @10.79.3.4 test.k31.com SOA
```
<img width="806" height="430" alt="image" src="https://github.com/user-attachments/assets/7d67d29f-ab9c-4648-9329-16a3e5f51982" />

Jika muncul IP → update otomatis sukses ✅

## Nomor 7
#### Soal
Peta kota dan pelabuhan dilukis. Sirion sebagai gerbang, Lindon sebagai web statis, Vingilot sebagai web dinamis. Tambahkan pada zona k31.com A record untuk sirion.k31.com (IP Sirion), lindon.k31.com (IP Lindon), dan vingilot.k31.com (IP Vingilot). Tetapkan CNAME:
www.k31.com → sirion.k31.com
static.k31.com → lindon.k31.com
app.k31.com → vingilot.k31.com
Verifikasi dari dua klien berbeda bahwa seluruh hostname tersebut ter-resolve ke tujuan yang benar dan konsisten.
#### Tujuan
Menambahkan record DNS untuk layanan web utama dan aliasnya agar seluruh hostname domain dapat diakses dengan benar dari seluruh host.
#### Step by Step
Konfigurasi di Tirion (Master DNS)
```
nano /etc/bind/zones/db.k31.com
Tambahkan:
$TTL 604800
@   IN  SOA ns1.k31.com. admin.k31.com. (
        2025101201 ; Serial (harus dinaikkan setiap update)
        3600
        1800
        604800
        30
)
; --- NS Record ---
    IN  NS  ns1.k31.com.
    IN  NS  ns2.k31.com.

; --- A Record ---
ns1     IN  A   10.79.3.3
ns2     IN  A   10.79.3.4
sirion  IN  A   10.79.3.2
lindon  IN  A   10.79.3.5
vingilot IN A   10.79.3.6

; --- CNAME Record ---
www     IN  CNAME sirion
static  IN  CNAME lindon
app     IN  CNAME vingilot
```
🟢 Penjelasan:
- A record → menghubungkan domain ke IP Address.
- CNAME → alias, jadi www.k31.com mengarah ke sirion.k31.com tanpa duplikasi IP.
- Serial harus dinaikkan agar slave tahu zona berubah.

4. Restart & Validasi Master
```
named-checkzone k31.com /etc/bind/zones/db.k31.com
named-checkconf
/usr/sbin/named -c /etc/bind/named.conf -f -u bind &
```
✅ Output: zone k31.com/IN: loaded serial 2025101201

5. Cek Sinkronisasi di Valmar (Slave)
Node: Valmar
Pastikan file hasil transfer ada:
```
ls -l /var/cache/bind/
```
Verifikasi record:
```
dig @10.79.3.4 sirion.k31.com A
dig @10.79.3.4 lindon.k31.com A
dig @10.79.3.4 vingilot.k31.com A
dig @10.79.3.4 www.k31.com CNAME
dig @10.79.3.4 static.k31.com CNAME
dig @10.79.3.4 app.k31.com CNAME
```
7. Uji dari Dua Klien

Node: Earendil dan Elrond

🔹 Tes query DNS:
```
dig sirion.k31.com
dig www.k31.com
dig static.k31.com
dig app.k31.com
```
<img width="709" height="478" alt="image" src="https://github.com/user-attachments/assets/d08fa78a-45ca-4216-97d3-904b8beeb6a0" />
<img width="709" height="491" alt="image" src="https://github.com/user-attachments/assets/4e1f720a-f02a-44c8-9e8d-6623cfc65b06" />

🔹 Tes konektivitas:
```
ping -c 2 sirion.k31.com
ping -c 2 static.k31.com
ping -c 2 app.k31.com
```
<img width="741" height="168" alt="image" src="https://github.com/user-attachments/assets/966d0c14-6a34-4c8b-9031-273aa634718a" />


## Nomor 8
#### Soal
Setiap jejak harus bisa diikuti. Di Tirion (ns1) deklarasikan satu reverse zone untuk segmen DMZ tempat Sirion, Lindon, dan Vingilot berada. Di Valmar (ns2) tarik reverse zone tersebut sebagai slave, isi PTR untuk ketiga hostname itu agar pencarian balik IP address mengembalikan hostname yang benar, lalu pastikan query reverse untuk alamat Sirion, Lindon, dan Vingilot dijawab authoritative.
#### Tujuan
Membuat reverse DNS zone agar setiap alamat IP di DMZ dapat dikembalikan ke hostname yang sesuai.
#### Step by Step
Tirion (10.79.3.3) — buka console Tirion, jalankan perintah ini persis.
Edit named.conf.local untuk tambahkan reverse zone (atau tambahkan blok baru jika sudah ada):
```
cat >> /etc/bind/named.conf.local <<'EOF'

zone "3.79.10.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.10.79.3";
    notify yes;
    allow-transfer { 10.79.3.4; };  // Valmar (ns2)
};
EOF
```
Buat file zone reverse /etc/bind/zones/db.10.79.3 (isi lengkap):
```
// Node: Tirion
cat > /etc/bind/zones/db.10.79.3 <<'EOF'
$TTL 604800
@   IN  SOA ns1.k31.com. admin.k31.com. (
        2025101201 ; Serial - naikkan tiap perubahan
        3600       ; Refresh
        1800       ; Retry
        604800     ; Expire
        30         ; Minimum TTL
)
        IN  NS  ns1.k31.com.
        IN  NS  ns2.k31.com.

; PTR records for DMZ 10.79.3.0/24
2       IN  PTR sirion.k31.com.
5       IN  PTR lindon.k31.com.
6       IN  PTR vingilot.k31.com.
EOF
```
Validasi zone file & konfigurasi:
```
// Node: Tirion
named-checkzone 3.79.10.in-addr.arpa /etc/bind/zones/db.10.79.3
named-checkconf

Restart bind di Tirion:
pkill named || true; /usr/sbin/named -c /etc/bind/named.conf -f -u bind &

Verifikasi local (di Tirion) bahwa PTR bekerja:
// Node: Tirion
dig @10.79.3.3 -x 10.79.3.2 +short   # harus mengembalikan sirion.k31.com.
dig @10.79.3.3 -x 10.79.3.5 +short   # harus mengembalikan lindon.k31.com.
dig @10.79.3.3 -x 10.79.3.6 +short   # harus mengembalikan vingilot.k31.com.
```
Valmar (10.79.3.4) — buka console Valmar.
Tambahkan deklarasi zone slave di named.conf.local (Valmar):
```
// Node: Valmar
cat >> /etc/bind/named.conf.local <<'EOF'

zone "3.79.10.in-addr.arpa" {
    type slave;
    file "/var/cache/bind/db.10.79.3";
    masters { 10.79.3.3; };  // Tirion (master)
};
EOF
```
Restart bind (atau jalankan named):
```
pkill named || true; /usr/sbin/named -c /etc/bind/named.conf -f -u bind &
```
Periksa apakah slave mendapat file zone:
```
// Node: Valmar
ls -l /var/cache/bind/ | grep db.10.79.3 || true
// Jika ada file, lanjut cek isi via dig (lebih aman karena file bisa biner)
dig @10.79.3.4 3.79.10.in-addr.arpa SOA
```
1) Di Tirion (cek master)
```
// Node: Tirion
dig @10.79.3.3 -x 10.79.3.2   ;# sirion
dig @10.79.3.3 -x 10.79.3.5   ;# lindon
dig @10.79.3.3 -x 10.79.3.6   ;# vingilot

// Perhatikan: di ANSWER SECTION harus ada PTR yang benar
// Dan header/flags harus menunjukkan authoritative (aa)
```
2) Di Valmar (cek slave)
```
// Node: Valmar
dig @10.79.3.4 -x 10.79.3.2
dig @10.79.3.4 -x 10.79.3.5
dig @10.79.3.4 -x 10.79.3.6
```
3) Di dua client (Earendil & Elrond) — objek test dari client
```
// Node: Earendil
dig -x 10.79.3.2
dig -x 10.79.3.5
dig -x 10.79.3.6

// Node: Elrond
dig -x 10.79.3.2
dig -x 10.79.3.5
dig -x 10.79.3.6
```
Bandingkan SOA / Serial & Cek Log
```
Pastikan serial reverse zone di master = serial di slave:
// Node: Tirion
dig @10.79.3.3 3.79.10.in-addr.arpa SOA | grep SOA

// Node: Valmar
dig @10.79.3.4 3.79.10.in-addr.arpa SOA | grep SOA

// Angka serial harus sama.
```
<img width="810" height="100" alt="image" src="https://github.com/user-attachments/assets/cc1d54d7-8e4a-4afa-a10f-918173888bf6" />

<img width="812" height="105" alt="image" src="https://github.com/user-attachments/assets/088507c1-c8ef-4853-b840-07390da80df5" />

## Nomor 9
#### Soal
Lampion Lindon dinyalakan. Jalankan web statis pada hostname static.k31.com dan buka folder arsip /annals/ dengan autoindex (directory listing) sehingga isinya dapat ditelusuri. Akses harus dilakukan melalui hostname, bukan IP.
#### Tujuan
Menjalankan web statis menggunakan Nginx di node Lindon dengan autoindex aktif untuk menampilkan isi direktori.
#### Step by Step
Perintah di Lindon (jalankan semua ini di console Lindon)
1) Install nginx
```
apt update && apt install -y nginx
```
2) Buat folder web untuk /annals/ dan tambahkan file contoh
```
mkdir -p /var/www/annals
// isi beberapa file contoh agar directory listing terlihat
echo "Annual report 2023" > /var/www/annals/report-2023.txt
echo "Logbook 2024" > /var/www/annals/log-2024.txt
// pastikan owner/nginx dapat baca
chown -R www-data:www-data /var/www/annals
chmod -R 755 /var/www/annals
```
3) Buat server block nginx untuk static.k31.com
```
cat > /etc/nginx/sites-available/static.k31.com <<'EOF'
server {
    listen 80;
    server_name static.k31.com;

    // root kita di /var/www (so URL /annals/ -> /var/www/annals)
    root /var/www;

    access_log /var/log/nginx/static_access.log;
    error_log  /var/log/nginx/static_error.log;

    // Pastikan /annals/ memiliki directory listing (autoindex)
    location /annals/ {
        autoindex on;
        autoindex_exact_size off;   # tampilkan ukuran lebih ramah
        autoindex_localtime on;
        allow all;
    }

    # Optional: block PHP execution (we only want static)
    location ~ \.php$ {
        return 404;
    }
}
EOF
```
4) Aktifkan site, disable default (opsional) dan restart nginx
```
ln -s /etc/nginx/sites-available/static.k31.com /etc/nginx/sites-enabled/static.k31.com
// disable default to avoid conflict (optional)
rm -f /etc/nginx/sites-enabled/default
nginx -t
service nginx restart

Klo error
rm /etc/nginx/sites-enabled/static.k31.com
ln -s /etc/nginx/sites-available/static.k31.com /etc/nginx/sites-enabled/static.k31.com
```
5) Verifikasi di Lindon (lokal)
```
// cek nginx listening
ss -ltnp | grep ':80' || netstat -ltnp | grep ':80'

// tes akses lokal (Host header tidak penting jika IP langsung)
curl -I http://localhost/annals/
// atau lihat listing HTML
curl http://localhost/annals/

Klo error
nano /etc/nginx/sites-available/static.k31.com 
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name static.k31.com;

    root /var/www/static.k31.com;
    index index.html;
}
```
Pastikan DNS (harus sudah ada dari No.7)
Di Lindon (atau Tirion) cek:
```
dig @10.79.3.3 static.k31.com A +short
dig @10.79.3.4 static.k31.com A +short
```
Verifikasi dari dua klien (Earendil & Elrond)
```
1) Di Earendil:
// cek resolv.conf memastikan DNS Tirion/Valmar
cat /etc/resolv.conf
```
<img width="396" height="89" alt="image" src="https://github.com/user-attachments/assets/a83f856a-0af0-4972-9ac8-00c84cd5f76b" />

```
// cek DNS resolve
dig static.k31.com +short
```
<img width="446" height="56" alt="image" src="https://github.com/user-attachments/assets/8d8d80cd-6137-4db8-9ab7-9a54aec1b1a0" />

```
// buka listing
curl -I http://static.k31.com/annals/
curl http://static.k31.com/annals/   // lihat HTML listing, harus ada file links
// atau gunakan browser di host PC jika port forwarding di GNS3
```
<img width="553" height="122" alt="image" src="https://github.com/user-attachments/assets/1f2b79cf-4f9b-41fc-819d-49ad750255ab" />

<img width="982" height="185" alt="image" src="https://github.com/user-attachments/assets/0dc527c2-5fa8-4b4b-93da-e12749691d9c" />

```
2) Di Elrond:
dig static.k31.com +short
curl -I http://static.k31.com/annals/
curl http://static.k31.com/annals/ | head -n 40
```
<img width="428" height="67" alt="image" src="https://github.com/user-attachments/assets/9481c69d-c2e3-4b10-8568-24dcbacae7d8" />

<img width="562" height="130" alt="image" src="https://github.com/user-attachments/assets/f8d99953-8b50-44e4-bdb5-61ba87d96893" />

<img width="978" height="247" alt="image" src="https://github.com/user-attachments/assets/b93e579d-b4c1-4f83-bee0-2d78142c5dec" />

## Nomor 10
#### Soal
Vingilot mengisahkan cerita dinamis. Jalankan web dinamis (PHP-FPM) pada hostname app.k31.com dengan beranda dan halaman about, serta terapkan rewrite sehingga /about berfungsi tanpa akhiran .php. Akses harus dilakukan melalui hostname.
#### Tujuan
Menjalankan web dinamis dengan PHP-FPM dan konfigurasi rewrite agar URL bersih dapat diakses di Vingilot.
#### Step by Step
**DI VINGILOT**

1️⃣ Instal Nginx dan PHP-FPM
```
apt update && apt install -y nginx php-fpm
apt update && apt install -y php php-fpm
```
2️⃣ Pastikan PHP-FPM aktif dan socket terbuat
```
ls /etc/init.d/ | grep fpm
service php8.4-fpm start
ls -l /run/php
```
🔹 Pastikan muncul file seperti /run/php/php8.4-fpm.sock

3️⃣ Buat folder web dan isi file PHP
```
mkdir -p /var/www/app
chown -R www-data:www-data /var/www/app
chmod -R 755 /var/www/app
```
📄 File /var/www/app/index.php
```
cat > /var/www/app/index.php <<'EOF'
<?php
echo "<h1>Welcome to app.k31.com</h1>";
echo "<p>This is the homepage served by PHP-FPM on Vingilot.</p>";
echo "<p><a href='/about'>About</a></p>";
?>
EOF
```
📄 File /var/www/app/about.php
```
cat > /var/www/app/about.php <<'EOF'
<?php
echo "<h1>About app.k31.com</h1>";
echo "<p>This is the About page. URL without .php should work: /about</p>";
echo "<p><a href='/'>Home</a></p>";
?>
EOF
```
4️⃣ Konfigurasi Nginx untuk app.k31.com
Buat file:
```
nano /etc/nginx/sites-available/app.k31.com
Isi dengan:
server {
    listen 80;
    server_name app.k31.com;
    root /var/www/app;
    index index.php index.html;
    access_log /var/log/nginx/app_access.log;
    error_log  /var/log/nginx/app_error.log;
    # Arahkan root ke index.php
    location / {
        try_files $uri $uri/ /index.php?$args;
    }
    # Rewrite agar /about tanpa .php tetap jalan
    location = /about {
        rewrite ^ /about.php last;
    }
    # Jalankan PHP lewat PHP-FPM
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
```
5️⃣ Aktifkan konfigurasi dan hapus default
```
ln -sf /etc/nginx/sites-available/app.k31.com /etc/nginx/sites-enabled/app.k31.com
rm -f /etc/nginx/sites-enabled/default
```
6️⃣ Tes konfigurasi & restart nginx
```
nginx -t
service nginx restart
```
7️⃣ Tes hasil
```
curl -I http://app.k31.com/
curl -I http://app.k31.com/about
```
<img width="442" height="266" alt="image" src="https://github.com/user-attachments/assets/b559c75a-daba-4d06-a605-6889652d6fb0" />

✅ Expected result:

HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8

dan jika dicek:
```
curl http://app.k31.com/about | head
```
akan menampilkan isi halaman PHP:
```
<h1>About app.k31.com</h1>
<p>This is the About page...</p>
```
<img width="1204" height="102" alt="image" src="https://github.com/user-attachments/assets/dad8b96c-8368-40f4-a915-bbd3873063b3" />

## Nomor 11
#### Soal
Di muara sungai, Sirion berdiri sebagai reverse proxy. Terapkan path-based routing: /static → Lindon dan /app → Vingilot, sambil meneruskan header Host dan X-Real-IP ke backend. Pastikan Sirion menerima www.<xxxx>.com (kanonik) dan sirion.<xxxx>.com, dan bahwa konten pada /static dan /app di-serve melalui backend yang tepat.


## Nomor 11
#### Soal
Sirion adalah penghubung antara dunia statis dan dinamis. Konfigurasikan **reverse proxy Nginx** di Sirion (10.79.3.2) agar permintaan ke:
- `/static/` diarahkan ke **Lindon (10.79.3.5)** — web statis.
- `/app/` diarahkan ke **Vingilot (10.79.3.6)** — web dinamis (PHP-FPM).
Akses dilakukan melalui hostname **www.k31.com** atau **sirion.k31.com**.

#### Tujuan
Membuat **Sirion** berfungsi sebagai **Reverse Proxy** yang mengarahkan request ke dua backend berbeda berdasarkan path menggunakan **Nginx**.

#### Step by Step
**DI SIRION**

---

1️⃣ **Bersihkan konfigurasi lama**

Hapus konfigurasi default agar tidak bentrok dan buat folder untuk halaman utama.

```bash
rm -f /etc/nginx/sites-enabled/*
rm -f /etc/nginx/sites-available/*
mkdir -p /var/www/sirion
mkdir -p /var/log/nginx/
