# Tubes-SoC-FPGA
Tugas besar kelompok 1
Nama\NIM Anggota 1	: Nirwan Saeful Rahman \ 1102220018
Nama\NIM Anggota 2	: Fabian Arron Kurniawan \ 101022300087
Nama\NIM Anggota 3	: Muhammad Yusril Arivaldy \ 1102210278


judul tugas besar 
Single-Layer INT8 Neural Network Accelerator Menggunakan Empat Sensor Ultrasonik Untuk Klasifikasi Multiclass

Deskripsi
Proyek ini bertujuan untuk merancang dan mengimplementasikan sebuah neural network accelerator berbasis FPGA yang digunakan untuk mempercepat proses inferensi neural network satu lapis (single-layer) dengan presisi INT8. 
Data masukan berasal dari empat sensor ultrasonik yang ditempatkan pada beberapa sisi objek (misalnya depan, belakang, kiri, kanan, dan atas) 
untuk mendeteksi jarak terhadap lingkungan sekitar. Accelerator ini difokuskan pada inferensi saja (bukan training) dan dirancang untuk bekerja secara real-time, berlatensi rendah, 
serta deterministik, sehingga cocok untuk sistem embedded dan robotika.

fungsi
Fungsi utama sistem ini adalah mengklasifikasikan kondisi lingkungan sekitar berdasarkan jarak objek yang terdeteksi oleh lima sensor ultrasonik.
Fungsi-fungsi utama:
1.	Mengambil data jarak dari empat sensor ultrasonik.
2.	Melakukan normalisasi dan kuantisasi data jarak ke format INT8.
3.	Memproses data masukan menggunakan single-layer fully connected neural network pada FPGA.
4.	Menghasilkan keluaran berupa klasifikasi tingkat kedekatan suatu objek (misalnya aman, peringatan, atau bahaya).
5.	Memberikan hasil inferensi secara cepat untuk digunakan oleh sistem kontrol atau monitoring.


fitur dan spesifikasi
1. Kontroller Ultrasonik : Mendapatkan kalkulasi jarak yang terdeteksi dari ultrasonik.
2. Quantizer	: Mengubah jarak yang terdeteksi dari ultrasonik menjadi tipe data 8 bit integer.
3. MAC	: Mengontrol lift 4 lantai
4. full connected layer : melakukan kalkulasi sederhana

spesifikasi
Contoh spesifikasi:
1. Bilangan memiliki lebar 32-bit
2. Vending machine dapat memberi kembalian
3. Lift dapat naik dan turun
4. Kalkulator menerima sampai 4 input

cara penggunaan
untuk cara penggunakan kami menggunakan flowchart, flowchart tertera pada link gdrive
https://drive.google.com/file/d/14UwgRuymiXlEy53I3IPn9DWjuvfpb_C4/view?usp=sharing



blok diagram
