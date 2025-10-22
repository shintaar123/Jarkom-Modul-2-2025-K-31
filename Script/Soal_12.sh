#!/bin/bash
#
# Skrip Pengerjaan Soal 12 - Proteksi /admin/ (Basic Auth)
#
# Skrip ini akan:
# 1. Menginstal apache2-utils (untuk htpasswd).
# 2. Membuat file password di /etc/nginx/.htpasswd (user: admin, pass: adminpass123).
# 3. Memodifikasi konfigurasi Nginx untuk memproteksi 'location /admin/'.
#
# *ASUMSI: Dijalankan setelah Soal 11 selesai.*
#

# Hentikan skrip jika ada perintah yang gagal
set -e

echo "[Soal 12] Memulai instalasi apache2-utils..."
apt-get update > /dev/null
apt-get install -y apache2-utils > /dev/null
echo "[Soal 12] apache2-utils berhasil diinstal."

# --- 2. Membuat File Password ---
echo "[Soal 12] Membuat file password di /etc/nginx/.htpasswd..."
# -c = Buat file baru
# -b = Mode batch (password dari command line)
# -B = Gunakan Bcrypt
htpasswd -cbB /etc/nginx/.htpasswd admin adminpass123
echo "[Soal 12] File .htpasswd berhasil dibuat (user: admin)."

# --- 3. Memodifikasi Konfigurasi Nginx ---
echo "[Soal 12] Memodifikasi /etc/nginx/sites-available/reverse-proxy.conf..."
# Kita timpa file konfigurasi dari Soal 11 dengan versi baru
# yang sudah menyertakan blok location /admin/
cat > /etc/nginx/sites-available/reverse-proxy.conf <<'EOF'
# Definisikan backend server
upstream static_backend {
    # Lindon (10.79.3.5)
    server 10.79.3.5;
}
upstream app_backend {
    # Vingilot (10.79.3.6)
    server 10.79.3.6;
}

server {
    listen 80;
    # Ini adalah state dari Soal 11 (sebelum kanonisasi Soal 13)
    server_name www.k31.com sirion.k31.com;

    access_log /var/log/nginx/reverse_access.log;
    error_log  /var/log/nginx/reverse_error.log;

    # --- BLOK BARU (NOMOR 12) ---
    location /admin/ {
        # 1. Pesan yang muncul di login prompt
        auth_basic "Restricted Admin Area";
        
        # 2. Path ke file password
        auth_basic_user_file /etc/nginx/.htpasswd;
        
        # 3. (Asumsi) Admin juga di-proxy ke Vingilot
        proxy_pass http://app_backend/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    # --- BATAS BLOK BARU ---

    # Blok dari Soal 11
    location /static/ {
        proxy_pass http://static_backend/;
