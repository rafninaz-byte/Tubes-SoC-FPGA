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

flowchart
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

flowchart
<img width="327" height="647" alt="image" src="https://github.com/user-attachments/assets/5238f842-c1ac-45ac-9fbe-440427aeef7a" />
<img width="423" height="680" alt="image" src="https://github.com/user-attachments/assets/1c8c7e12-07f6-4239-9e9d-8f362f1eb1ee" />
penjelasan
Flowchart tersebut menunjukkan alur kerja sistem yang diawali dengan proses inisialisasi sensor ultrasonik, FPGA, serta parameter neural network seperti weight dan bias. Setelah itu, sistem menentukan batas jarak (threshold) untuk membedakan kondisi aman, waspada, dan berbahaya. Sensor ultrasonik kemudian membaca jarak objek di sekitar secara terus-menerus. Data jarak yang diperoleh akan dibandingkan dengan threshold, dan jika memenuhi syarat, data tersebut diproses oleh Neural Network Accelerator untuk menentukan klasifikasi kondisi. Hasil klasifikasi selanjutnya ditampilkan melalui indikator LED sesuai dengan kondisi yang terdeteksi. Proses ini berlangsung secara berulang sehingga sistem dapat memantau kondisi lingkungan secara real-time.




blok diagram
<img width="1280" height="845" alt="image" src="https://github.com/user-attachments/assets/03c52416-3ea2-4e53-af7c-f1c78dd0bf0f" />
penjelasan 
Berdasarkan diagram blok yang telah dirancang, sistem ini menggabungkan sensor ultrasonik, FPGA, dan Neural Network Accelerator (NNA) untuk melakukan deteksi dan klasifikasi kondisi lingkungan secara real-time. FPGA berfungsi sebagai pusat pengendali yang mengatur pembacaan data dari sensor ultrasonik, pengecekan batas jarak (threshold), serta proses klasifikasi menggunakan NNA. Hasil klasifikasi kemudian ditampilkan melalui indikator LED sehingga kondisi lingkungan dapat diketahui dengan mudah. Dengan memanfaatkan kemampuan komputasi paralel pada FPGA dan NNA, sistem ini dapat bekerja dengan cepat dan efisien, sehingga sesuai untuk diterapkan pada aplikasi pendeteksian objek atau sistem keamanan berbasis jarak.


FSM
(menjelaskan cara kerja dan transisi dalam fsm)
penjelasan blok


FSM (mealy machine)

State


tabel transisi fsm mealy (pola 101)



hasil simulasi dan analisis
<img width="1508" height="764" alt="image" src="https://github.com/user-attachments/assets/fd6b0768-d54b-4f21-990b-fa52718ce7d5" />

Dari waveform simulasi yang ditampilkan, bisa dilihat kalau sistem berjalan sesuai dengan alur yang dirancang. Sinyal **clock (clk)** terlihat stabil sepanjang simulasi, yang menandakan sistem sinkron bekerja dengan baik. Di awal simulasi, **reset (rst)** aktif untuk menginisialisasi sistem, lalu dinonaktifkan agar rangkaian siap digunakan. Setelah itu, sinyal **start** diberikan sebentar sebagai tanda bahwa proses komputasi pada Neural Network Accelerator mulai dijalankan.

Nilai input **x0, x1, x2, dan x3** terlihat sudah stabil dengan nilai 13, 76, 24, dan 82 yang mewakili data dari sensor. Saat sinyal start aktif, sistem mulai melakukan proses klasifikasi berdasarkan data tersebut. Selama proses berlangsung, sinyal **done** masih bernilai rendah, artinya proses belum selesai. Di akhir simulasi, sinyal **done** berubah menjadi aktif dan nilai **class_id** muncul (bernilai 10) sebagai hasil klasifikasi. Hal ini menunjukkan bahwa sistem berhasil memproses input dan menghasilkan output sesuai dengan desain yang telah dibuat.







Lampiran (kode verilog)





link video implementasi
https://drive.google.com/file/d/1qvzWCa3wwLiYrUb09nVLZsgdOJ7CDhSX/view?usp=sharing


