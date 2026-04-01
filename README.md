<p align="center">
  <img src="assets/logo.png" alt="Bloodinary Logo" width="600">
</p>

---

# 🩸 Bloodinary v1.0.0

[![Gem Version](https://img.shields.io/badge/gem-v1.0.0-red.svg)](https://rubygems.org/gems/bloodinary)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Bloodinary** adalah alat analisis keamanan statis (*Static Analysis Security Testing* - SAST) premium untuk aplikasi Ruby. Dirancang khusus untuk mendeteksi kerentanan keamanan tingkat tinggi dengan tingkat akurasi yang lebih tajam dibandingkan alat tradisional pada framework kustom.

---

## ✨ Fitur Unggulan

- **🔍 Analisis AST**: Melakukan pemindaian kode sumber tanpa mengeksekusinya, menjamin keamanan 100% pada lingkungan pengembangan.
- **🚀 Ultra Fast**: Performa pemindaian kilat, mampu memproses ribuan baris kode dalam hitungan milidetik.
- **📁 Dukungan ERB & Template**: Mendeteksi celah XSS di file `.erb`, `.html`, `.haml`, dan `.slim`.
- **🛡️ Aturan Keamanan Komprehensif**:
  - **SQL Injection**: Mendeteksi kueri database yang tidak aman.
  - **Cross-Site Scripting (XSS)**: Memantau output dinamis yang berbahaya.
  - **Command Injection**: Melacak eksekusi sistem yang berisiko.
  - **Path Traversal**: Mengaudit akses file sistem secara dinamis.
  - **Insecure Redirect**: Mencegah pengalihan ke situs phishing.
  - **Weak Crypto**: Mendeteksi algoritma hashing usang (MD5/SHA1).

---

## 🛠️ Instalasi

Tambahkan baris ini ke dalam Gemfile aplikasi Anda:

```ruby
gem 'bloodinary'
```

Lalu jalankan:
```bash
bundle install
```

Atau instal secara manual dengan:
```bash
gem install bloodinary
```

---

## 🚀 Penggunaan

Jalankan Bloodinary pada direktori proyek Anda:

```bash
# Pemindaian standar
bloodinary .

# Output dalam format JSON untuk integrasi CI/CD
bloodinary . --format json

# Menyimpan laporan ke file
bloodinary . --output laporan_keamanan.txt

# Mengabaikan folder tertentu
bloodinary . --ignore-path vendor/,spec/
```

### Opsi CLI Lengkap:

| Opsi | Deskripsi |
|------|-----------|
| `-f, --format` | Pilih format laporan (`text`, `json`). |
| `-o, --output` | Simpan laporan ke file tertentu. |
| `--ignore-path` | Lewati folder atau file (pisahkan dengan koma). |
| `--exit-on-warn` | Berhenti dengan kode 1 jika menemukan celah keamanan. |
| `-v, --version` | Tampilkan versi Bloodinary. |

---

## 🧩 Pengabaian Temuan (Ignore)

Jika Anda yakin suatu baris kode aman, Anda bisa menambah komentar di akhir baris untuk mengabaikannya:

```ruby
system("ls #{user_input}") # bloodinary:ignore
```

---

## 📄 Lisensi

Proyek ini dilisensikan di bawah **Lisensi MIT** - lihat file [LICENSE](LICENSE) untuk detail lebih lanjut.