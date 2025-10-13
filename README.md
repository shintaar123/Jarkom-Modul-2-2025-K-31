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
<img width="376" height="296" alt="image" src="https://github.com/user-attachments/assets/e4d9c9ee-10ca-438e-8063-dc9e88c8f838" />

#### Soal
Di tepi Beleriand yang porak-poranda, Eonwe merentangkan tiga jalur: Barat untuk Earendil dan Elwing, Timur untuk Círdan, Elrond, Maglor, serta pelabuhan DMZ bagi Sirion, Tirion, Valmar, Lindon, Vingilot. Tetapkan alamat dan default gateway tiap tokoh sesuai glosarium yang sudah diberikan.
#### Tujuan
Menentukan konfigurasi alamat IP dan gateway untuk seluruh node agar setiap host dapat saling terhubung melalui router Eonwe.
#### Step by Step

## Nomor 2
#### Soal
Angin dari luar mulai berhembus ketika Eonwe membuka jalan ke awan NAT. Pastikan jalur WAN di router aktif dan NAT meneruskan trafik keluar bagi seluruh alamat internal sehingga host di dalam dapat mencapai layanan di luar menggunakan IP address.
#### Tujuan
Mengaktifkan NAT di router agar seluruh host internal dapat mengakses jaringan eksternal (internet).
#### Step by Step

## Nomor 3
#### Soal
Kabar dari Barat menyapa Timur. Pastikan kelima klien dapat saling berkomunikasi lintas jalur (routing internal via Eonwe berfungsi), lalu pastikan setiap host non-router menambahkan resolver 192.168.122.1 saat interfacenya aktif agar akses paket dari internet tersedia sejak awal.
#### Tujuan
Memastikan routing antar subnet berjalan dan semua klien dapat menggunakan DNS eksternal untuk mengunduh paket internet.
#### Step by Step

## Nomor 4
#### Soal
Para penjaga nama naik ke menara, di Tirion (ns1/master) bangun zona k31.com sebagai authoritative dengan SOA yang menunjuk ke ns1.k31.com dan catatan NS untuk ns1.k31.com dan ns2.k31.com. Buat A record untuk ns1.k31.com dan ns2.k31.com yang mengarah ke alamat Tirion dan Valmar sesuai glosarium, serta A record apex k31.com yang mengarah ke alamat Sirion (front door), aktifkan notify dan allow-transfer ke Valmar, set forwarders ke 192.168.122.1. Di Valmar (ns2/slave) tarik zona k31.com dari Tirion dan pastikan menjawab authoritative.
Pada seluruh host non-router ubah urutan resolver menjadi ns1.k31.com → ns2.k31.com → 192.168.122.1. Verifikasi query ke apex dan hostname layanan dalam zona dijawab melalui ns1/ns2.
#### Tujuan
Membangun DNS master–slave untuk domain k31.com agar semua host dapat resolve domain secara internal.
#### Step by Step

## Nomor 5
#### Soal
“Nama memberi arah,” kata Eonwe. Namai semua tokoh (hostname) sesuai glosarium: eonwe, earendil, elwing, cirdan, elrond, maglor, sirion, tirion, valmar, lindon, vingilot. Verifikasi bahwa setiap host mengenali dan menggunakan hostname tersebut secara system-wide. Buat setiap domain untuk masing-masing node sesuai namanya (contoh: eru.k31.com) dan assign IP masing-masing juga. Lakukan pengecualian untuk node yang bertanggung jawab atas ns1 dan ns2.
#### Tujuan
Menetapkan hostname dan domain untuk setiap node agar dapat dikenali melalui DNS internal.
#### Step by Step

## Nomor 6

## Nomor 7

## Nomor 8

## Nomor 9

## Nomor 10
