Saya ingin kamu melakukan analisis dan patch pada APK Android Pony Town yang tersedia di workspace.

Tujuan utama

Modifikasi APK agar:

1. Menjalankan Foreground Service ketika aplikasi Pony Town dibuka.
2. Menampilkan persistent notification selama service berjalan.
3. Menambahkan fondasi Custom JavaScript Injector untuk WebView Pony Town.
4. Tidak merusak fungsi utama aplikasi.
5. Menghasilkan hasil patch yang siap saya rebuild dan sign sendiri menggunakan MT Manager.

JANGAN hanya menjelaskan langkah-langkah. Kerjakan analisis dan modifikasi file secara langsung di workspace.

---

BAGIAN 1: ANALISIS APK

Sebelum memodifikasi apa pun:

1. Analisis struktur APK.
2. Decode APK menggunakan apktool atau tool yang tersedia.
3. Periksa:
   - AndroidManifest.xml
   - Application class
   - MainActivity / Launcher Activity
   - Service yang sudah ada
   - package name
   - minSdkVersion
   - targetSdkVersion
4. Cari implementasi WebView Pony Town.

Fokus mencari class seperti:

- PonyTownWebViewImpl
- PonyTownInterface
- MainActivity
- WebView
- WebViewClient
- WebChromeClient
- evaluateJavascript
- addJavascriptInterface
- addDocumentStartJavaScript

Jangan mengasumsikan struktur class. Gunakan hasil analisis APK yang sebenarnya.

Sebelum patch, buat catatan singkat:

- Entry point aplikasi
- Package name
- Lokasi implementasi WebView
- Lokasi terbaik untuk memulai Foreground Service
- Lokasi terbaik untuk JavaScript injection

---

BAGIAN 2: FOREGROUND SERVICE

Tambahkan Foreground Service yang kompatibel dengan versi Android yang didukung aplikasi.

Service harus:

1. Dimulai otomatis ketika aplikasi Pony Town dibuka.
2. Memanggil startForeground() sesuai requirement Android.
3. Membuat Notification Channel pada Android 8+.
4. Menampilkan persistent notification.
5. Tidak dapat dihapus secara normal selama service berjalan.
6. Memiliki nama notification:

"Pony Town Running"

7. Memiliki teks:

"Keeping Pony Town active"

Gunakan implementasi native Android yang paling kompatibel dengan APK.

Jika APK menggunakan Java, gunakan Java/smali yang sesuai.
Jika APK menggunakan Kotlin, sesuaikan dengan struktur bytecode yang ada.

Jangan menambahkan dependency Gradle karena APK sudah berupa hasil build.

---

BAGIAN 3: MANIFEST PATCH

Patch AndroidManifest.xml seperlunya.

Tambahkan permission yang benar dan benar-benar diperlukan.

Deklarasikan Foreground Service dengan benar.

Jangan menambahkan permission berlebihan.

Perhatikan kompatibilitas Android modern.

Jangan merusak existing Application, Activity, Service, Receiver, atau Provider.

---

BAGIAN 4: SERVICE STARTUP

Cari titik startup aplikasi yang paling aman.

Prioritas:

Application.onCreate()

atau

Launcher/MainActivity.onCreate()

Pilih berdasarkan struktur APK yang sebenarnya.

Tambahkan kode agar Foreground Service dimulai ketika aplikasi dibuka.

Untuk Android modern, gunakan:

startForegroundService()

jika diperlukan.

Untuk Android lama gunakan:

startService()

jika sesuai.

Pastikan tidak menyebabkan crash karena background execution restrictions.

---

BAGIAN 5: CUSTOM JAVASCRIPT INJECTOR

APK Pony Town menggunakan WebView.

Tambahkan fondasi Custom JavaScript Injector.

Jangan mengubah JavaScript asli Pony Town.

Buat sistem injector terpisah.

Injector harus mendukung:

Mode 1: Document Start

Jika WebView AndroidX/WebKit yang digunakan APK mendukung document-start injection:

- Gunakan API yang sudah tersedia.
- Inject script sebelum halaman Pony Town menjalankan sebagian besar JavaScript.

Jika tidak tersedia:

- Gunakan fallback paling awal yang aman.

Mode 2: Page Finished

Tambahkan injection setelah halaman selesai dimuat menggunakan WebViewClient.

Gunakan:

evaluateJavascript()

atau mekanisme yang sudah digunakan APK.

---

BAGIAN 6: SCRIPT STORAGE

Buat sistem sederhana untuk membaca Custom JavaScript.

Prioritas lokasi:

External app storage:

/Android/data/<package_name>/files/scripts/

Contoh:

custom.js

Jika external storage tidak cocok dengan struktur Android versi target:

Gunakan internal app files directory.

Jangan meminta permission storage lama jika tidak diperlukan.

Script harus:

1. Dibaca sebagai text.
2. Diinject ke WebView.
3. Hanya dijalankan pada domain Pony Town.

Domain yang diizinkan:

https://pony.town/

https://*.pony.town/

Jangan menjalankan script pada domain lain secara default.

---

BAGIAN 7: JAVASCRIPT WRAPPER

Bungkus custom script dengan error handling agar error dari script tidak langsung merusak aplikasi.

Contoh konsep:

(function() {
try {

    // custom user script

} catch (error) {
    console.error("Custom Script Error:", error);
}

})();

Sesuaikan implementasi agar valid ketika dimasukkan melalui evaluateJavascript atau document-start injection.

Jangan hardcode isi custom script.

Script harus dibaca dari file.

---

BAGIAN 8: URL CHECK

Sebelum menjalankan script:

Periksa URL WebView.

Script hanya boleh berjalan jika hostname cocok dengan:

pony.town

atau subdomain Pony Town yang relevan.

Gunakan pengecekan yang aman.

Jangan menggunakan:

url.contains("pony.town")

secara sembarangan karena domain palsu seperti:

pony.town.evil-example.com

tidak boleh lolos.

Gunakan hostname/domain parsing yang benar jika memungkinkan.

---

BAGIAN 9: KOMPATIBILITAS

Patch harus mempertimbangkan:

- Android 8+
- Android 10+
- Android 12+
- Android 13+
- Android 14+

Jangan mengklaim kompatibilitas sempurna jika tidak dapat diverifikasi.

Jelaskan keterbatasan Android yang dapat menyebabkan Foreground Service atau WebView dibatasi sistem.

Jangan menambahkan WakeLock secara default.

WakeLock hanya boleh ditambahkan jika memang dibutuhkan dan harus dibuat opsional karena dapat menguras baterai.

---

BAGIAN 10: JANGAN LAKUKAN

Jangan:

- Menghapus fitur asli Pony Town.
- Mengubah URL game utama.
- Mengubah login.
- Memodifikasi autentikasi.
- Mem-bypass pembayaran.
- Mem-bypass security server.
- Memodifikasi network protocol.
- Menambahkan spyware.
- Mengirim data ke server pihak ketiga.
- Menambahkan analytics.
- Menambahkan dependency online yang tidak diperlukan.
- Mengubah signature asli secara paksa.
- Mengklaim APK sudah signed jika belum benar-benar ditandatangani.

---

BAGIAN 11: VALIDASI

Setelah patch:

1. Periksa AndroidManifest.xml.
2. Periksa semua class/smali yang dimodifikasi.
3. Pastikan referensi class benar.
4. Pastikan method descriptor smali benar.
5. Periksa register count jika memodifikasi smali.
6. Pastikan tidak ada reference class yang hilang.
7. Validasi struktur hasil decode.

Jika tool build tersedia:

- Coba rebuild APK.

Jika rebuild gagal:

- Debug error.
- Perbaiki.
- Coba lagi.

Jika build berhasil:

JANGAN menganggap APK pasti berjalan sempurna.

Jelaskan bahwa runtime test tetap diperlukan.

---

BAGIAN 12: OUTPUT

Berikan:

1. Folder APK hasil decode yang sudah dipatch.
2. Daftar file yang dimodifikasi.
3. Penjelasan singkat setiap perubahan.
4. Lokasi folder hasil patch.
5. Jika berhasil rebuild, berikan APK hasil rebuild.
6. Jangan sign APK jika saya akan sign sendiri menggunakan MT Manager.

Struktur output yang diharapkan:

PATCH_REPORT.md

Berisi:

Modified Files

- AndroidManifest.xml
- [file lainnya]

Foreground Service

Jelaskan:

- Nama class service
- Lokasi class
- Cara service dimulai
- Notification Channel ID

JavaScript Injector

Jelaskan:

- Lokasi injector
- Kapan document-start injection dilakukan
- Kapan page-finished injection dilakukan
- Lokasi custom.js

Build Status

- SUCCESS / FAILED

Jika FAILED:

- Error
- Penyebab
- File yang perlu diperbaiki

---

PENTING

Kerjakan secara bertahap:

1. Analyze
2. Decode
3. Locate WebView
4. Locate startup point
5. Patch Foreground Service
6. Validate patch
7. Patch JavaScript Injector
8. Validate patch
9. Rebuild jika memungkinkan
10. Generate PATCH_REPORT.md

Jangan berhenti setelah analisis.

Jangan hanya memberikan tutorial.

Lakukan modifikasi file secara nyata.

Jika ada beberapa kemungkinan titik patch, pilih berdasarkan struktur APK asli, bukan asumsi.

Prioritas utama:

APK tetap dapat berjalan tanpa merusak fungsi utama Pony Town.

Prioritas kedua:

Foreground Service stabil.

Prioritas ketiga:

Custom JavaScript Injector berfungsi.