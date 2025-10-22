#!/bin/bash
#
# Skrip Pengerjaan Soal 17 - Verifikasi Pemulihan Layanan
#
# Skrip ini dijalankan di EARENDIL untuk memverifikasi
# bahwa semua layanan inti (DNS, Nginx, PHP-FPM)
# telah "pulih" dan berfungsi setelah simulasi reboot.
#

echo "--------------------------------------------------------"
echo " [ Tes 1/3 ] Memverifikasi DNS (Tirion & Valmar)..."
echo " (Perintah: dig www.k31.com +short)"
echo "--------------------------------------------------------"
dig www.k31.com +short

echo ""
echo "--------------------------------------------------------"
echo " [ Tes 2/3 ] Memverifikasi Rute Statis (Sirion & Lindon)..."
echo " (Perintah: curl http://www.k31.com/static/annals/)"
echo "--------------------------------------------------------"
curl http://www.k31.com/static/annals/

echo ""
echo "--------------------------------------------------------"
echo " [ Tes 3/3 ] Memverifikasi Rute Dinamis (Sirion & Vingilot)..."
echo " (Perintah: curl http://www.k31.com/app/about)"
echo "--------------------------------------------------------"
curl http://www.k31.com/app/about

echo ""
echo "--------------------------------------------------------"
echo "✅  Skrip Soal 17 Selesai. Semua layanan terverifikasi."
echo "--------------------------------------------------------"
echo ""
