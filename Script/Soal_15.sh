#!/bin/bash
# ================================
# Soal 15 - Uji Koneksi & Load Testing
# Tujuan:
# 1. Melakukan koneksi ke server via Telnet untuk analisis stabilitas koneksi.
# 2. Menguji performa endpoint dinamis & statis menggunakan ApacheBench (ab).
# ================================

# --------------------------------
# Bagian 1: Uji Koneksi via Telnet
# --------------------------------
echo "[+] Menguji koneksi ke server 10.15.43.32 pada port 5484..."
telnet 10.15.43.32 5484

# Analisis:
# - Telnet berhasil terkoneksi:
#     Trying 10.15.43.32...
#     Connected to 10.15.43.32.
#     Escape character is '^]'.
# - Namun respon lambat (lag), kemungkinan disebabkan oleh:
#     1. Server overload atau proses di port 5484 berat.
#     2. Latency jaringan tinggi.
#     3. Firewall atau IDS menunda paket TCP sebagian.
#
# Kesimpulan:
# Koneksi berhasil, tetapi respons lambat — indikasi potensi bottleneck di sisi server.

# --------------------------------
# Bagian 2: Load Testing (ApacheBench)
# --------------------------------

echo "[+] Memulai pengujian performa endpoint menggunakan ApacheBench..."
apt update -y
apt install apache2-utils -y

# 1. Uji Endpoint Dinamis (Vingilot)
echo "[+] Uji endpoint dinamis (/app/)..."
ab -n 500 -c 10 -k "https://www.k31.com/app/"

# Hasil Pengujian (/app/):
# Complete requests:      500
# Failed requests:        0
# Requests per second:    94.69 [#/sec] (mean)
# Time per request:       105.609 [ms] (mean)
# Transfer rate:          22.19 [Kbytes/sec] received
# 100% requests selesai dalam 458 ms (longest request)

# 2. Uji Endpoint Statis (Lindon)
echo "[+] Uji endpoint statis (/static/)..."
ab -n 500 -c 10 -k "https://www.k31.com/static/"

# Hasil Pengujian (/static/):
# Complete requests:      500
# Failed requests:        0
# Requests per second:    99.48 [#/sec] (mean)
# Time per request:       100.524 [ms] (mean)
# Transfer rate:          23.32 [Kbytes/sec] received
# 100% requests selesai dalam 303 ms (longest request)

# --------------------------------
# Ringkasan Hasil
# --------------------------------
echo
echo "+-------------------+----------------+-------------+------------------------+----------------+"
echo "| Endpoint          | Total Requests | Concurrency | Requests per Second    | Failed Requests|"
echo "+-------------------+----------------+-------------+------------------------+----------------+"
echo "| Dinamis (/app/)   | 500            | 10          | 94.69                  | 0              |"
echo "| Statis (/static/) | 500            | 10          | 99.48                  | 0              |"
echo "+-------------------+----------------+-------------+------------------------+----------------+"

# --------------------------------
# Analisis Akhir
# --------------------------------
# Kedua endpoint stabil (tidak ada request gagal).
# Endpoint statis (/static/) memiliki performa lebih tinggi (99.48 vs 94.69 req/s).
# Penyebab:
#    - Endpoint statis langsung disajikan oleh Nginx (file cache, tanpa PHP).
#    - Endpoint dinamis memerlukan pemrosesan PHP-FPM, menambah overhead CPU.
# Implikasi:
#    - Untuk konten dinamis, optimalkan caching atau gunakan load balancer.
#    - Untuk file statis, sudah optimal.

# ================================
# Selesai
# ================================
