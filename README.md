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

## Nomor 5
#### Soal
“Nama memberi arah,” kata Eonwe. Namai semua tokoh (hostname) sesuai glosarium: eonwe, earendil, elwing, cirdan, elrond, maglor, sirion, tirion, valmar, lindon, vingilot. Verifikasi bahwa setiap host mengenali dan menggunakan hostname tersebut secara system-wide. Buat setiap domain untuk masing-masing node sesuai namanya (contoh: eru.k31.com) dan assign IP masing-masing juga. Lakukan pengecualian untuk node yang bertanggung jawab atas ns1 dan ns2.
#### Tujuan
Menetapkan hostname dan domain untuk setiap node agar dapat dikenali melalui DNS internal.
#### Step by Step

## Nomor 6
#### Soal
Lonceng Valmar berdentang mengikuti irama Tirion. Pastikan zone transfer berjalan, pastikan Valmar (ns2) telah menerima salinan zona terbaru dari Tirion (ns1). Nilai serial SOA di keduanya harus sama.
#### Tujuan
Memastikan mekanisme sinkronisasi zona DNS antara master (Tirion) dan slave (Valmar) berjalan otomatis.
#### Step by Step

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

## Nomor 8
#### Soal
Setiap jejak harus bisa diikuti. Di Tirion (ns1) deklarasikan satu reverse zone untuk segmen DMZ tempat Sirion, Lindon, dan Vingilot berada. Di Valmar (ns2) tarik reverse zone tersebut sebagai slave, isi PTR untuk ketiga hostname itu agar pencarian balik IP address mengembalikan hostname yang benar, lalu pastikan query reverse untuk alamat Sirion, Lindon, dan Vingilot dijawab authoritative.
#### Tujuan
Membuat reverse DNS zone agar setiap alamat IP di DMZ dapat dikembalikan ke hostname yang sesuai.
#### Step by Step

## Nomor 9
#### Soal
Lampion Lindon dinyalakan. Jalankan web statis pada hostname static.k31.com dan buka folder arsip /annals/ dengan autoindex (directory listing) sehingga isinya dapat ditelusuri. Akses harus dilakukan melalui hostname, bukan IP.
#### Tujuan
Menjalankan web statis menggunakan Nginx di node Lindon dengan autoindex aktif untuk menampilkan isi direktori.
#### Step by Step

## Nomor 10
#### Soal
Vingilot mengisahkan cerita dinamis. Jalankan web dinamis (PHP-FPM) pada hostname app.k31.com dengan beranda dan halaman about, serta terapkan rewrite sehingga /about berfungsi tanpa akhiran .php. Akses harus dilakukan melalui hostname.
#### Tujuan
Menjalankan web dinamis dengan PHP-FPM dan konfigurasi rewrite agar URL bersih dapat diakses di Vingilot.
#### Step by Step
