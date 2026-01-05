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


fitur 
Ultrasonic_Accelerator ⁠

Fungsi Mengontrol dan membaca *4 sensor ultrasonik HC-SR04* secara bergantian untuk menghasilkan jarak dalam satuan sentimeter.

Fitur

•⁠  ⁠Menggunakan *FSM berbasis Moore*
•⁠  ⁠Scanning 4 sensor secara multiplexed
•⁠  ⁠Menghasilkan sinyal *TRIG otomatis*
•⁠  ⁠Mengukur lebar pulsa *ECHO*
•⁠  ⁠Timeout protection jika objek tidak terdeteksi

 Spesifikasi Teknis

| Parameter         | Nilai                      |
| ----------------- | -------------------------- |
| Clock             | 50 MHz                     |
| Jumlah sensor     | 4                          |
| Resolusi jarak    | cm                         |
| Metode pengukuran | Echo pulse width           |
| FSM states        | IDLE, TRIG_S, WAIT_E, NEXT |
| Output            | ⁠ distance_cm0..3 ⁠ (16-bit) |


Distance_To_INT8.v ⁠

Fungsi : Melakukan *normalisasi dan kuantisasi* jarak ultrasonik menjadi *INT8* agar kompatibel dengan NN accelerator.

Fitur

•⁠  ⁠Konversi jarak cm → INT8
•⁠  ⁠Clipping otomatis (overflow protection)
•⁠  ⁠Tidak menggunakan operasi floating-point

### ⚙️ Spesifikasi Teknis

| Parameter  | Nilai                    |
| ---------- | ------------------------ |
| Input      | 16-bit unsigned distance |
| Output     | 8-bit signed             |
| Format     | Fixed-point INT8         |
| Latensi    | 1 clock                  |
| Arithmetic | Integer only             |


Distance_Change_Detector.v ⁠

Fungsi : Mendeteksi *perubahan jarak signifikan* dan menghasilkan *start pulse* untuk memicu neural network.

 Fitur

•⁠  ⁠Event-driven inference
•⁠  ⁠Menghindari eksekusi NN berulang
•⁠  ⁠Mengurangi flickering output
•⁠  ⁠Threshold dapat dikonfigurasi

Spesifikasi Teknis

| Parameter | Nilai                |
| --------- | -------------------- |
| Input     | 4× distance_cm       |
| Output    | ⁠ start_pulse ⁠        |
| Threshold | Parameterizable (cm) |
| Mode      | Edge-based trigger   |
| Latensi   | 1 clock              |

---

Weight_Memory.v ⁠

Fungsi : Menyimpan *bobot neural network* hasil training dalam bentuk ROM.

Fitur

•⁠  ⁠ROM berbasis case-statement
•⁠  ⁠Akses berdasarkan ⁠ in_idx ⁠ dan ⁠ out_idx ⁠
•⁠  ⁠Mendukung bobot INT8

Spesifikasi Teknis

| Parameter    | Nilai           |
| ------------ | --------------- |
| Bobot        | INT8            |
| Struktur     | Fully connected |
| Input index  | 2-bit           |
| Output index | 2-bit           |
| Implementasi | LUT-based ROM   |

---

Bias_Memory.v ⁠

Fungsi Menyediakan *bias neuron output* untuk neural network.

Fitur

•⁠  ⁠Bias per neuron
•⁠  ⁠Konstanta hasil training
•⁠  ⁠Akses sinkron dengan neuron index

Spesifikasi Teknis

| Parameter     | Nilai     |
| ------------- | --------- |
| Bias format   | INT16     |
| Jumlah neuron | 3         |
| Address       | ⁠ out_idx ⁠ |
| Implementasi  | ROM       |

---

MAC.v ⁠

Fungsi : Melakukan operasi *Multiply–Accumulate (MAC)* sebagai inti komputasi neural network.

Fitur

•⁠  ⁠INT8 × INT8 multiplication
•⁠  ⁠Akumulasi ke INT32
•⁠  ⁠Enable-controlled operation

Spesifikasi Teknis

| Parameter | Nilai      |
| --------- | ---------- |
| Input x   | INT8       |
| Input w   | INT8       |
| Output    | INT32      |
| Mode      | Sequential |
| Latensi   | 1 clock    |



MAC_Controller.v ⁠

Fungsi Mengontrol urutan operasi neural network menggunakan *FSM*.

Fitur

•⁠  ⁠Mengatur ⁠ in_idx ⁠ dan ⁠ out_idx ⁠
•⁠  ⁠Menghasilkan ⁠ mac_en ⁠
•⁠  ⁠Mengontrol siklus inference
•⁠  ⁠Menghasilkan sinyal ⁠ done ⁠

Spesifikasi Teknis

| Parameter            | Nilai                                   |
| -------------------- | --------------------------------------- |
| FSM type             | Moore FSM                               |
| Jumlah input         | 4                                       |
| Jumlah output neuron | 3                                       |
| FSM states           | IDLE, MAC_OP, NEXT_IN, NEXT_OUT, FINISH |
| Output               | ⁠ mac_en ⁠, ⁠ done ⁠                        |



relu.v ⁠

Fungsi  : Mengimplementasikan *fungsi aktivasi ReLU* pada hasil neuron.

 Fitur

•⁠  ⁠Non-linear activation
•⁠  ⁠Hardware-friendly
•⁠  ⁠Zeroing nilai negatif

Spesifikasi Teknis

| Parameter | Nilai     |
| --------- | --------- |
| Input     | INT32     |
| Output    | INT32     |
| Fungsi    | max(0, x) |
| Latensi   | 1 clock   |



Argmax3.v ⁠

Fungsi Menentukan *kelas output* berdasarkan nilai neuron terbesar.
Fitur

•⁠  ⁠Membandingkan 3 output neuron
•⁠  ⁠Output stabil (latched)
•⁠  ⁠Sinkron dengan sinyal ⁠ valid ⁠

Spesifikasi Teknis

| Parameter | Nilai             |
| --------- | ----------------- |
| Input     | 3× INT32          |
| Output    | 2-bit class index |
| Trigger   | ⁠ valid ⁠           |
| Mode      | Sequential        |
| Latensi   | 1 clock           |

---

NNA_TOP.⁠

Fungsi Mengintegrasikan seluruh komponen *Neural Network Accelerator*.

Fitur

•⁠  ⁠Input MUX untuk reuse MAC
•⁠  ⁠Penyimpanan hasil neuron
•⁠  ⁠Sinkronisasi FSM & MAC
•⁠  ⁠Konversi hasil NN ke LED

Spesifikasi Teknis

| Parameter | Nilai            |
| --------- | ---------------- |
| Input     | 4× INT8          |
| Output    | 3-class decision |
| MAC count | 1                |
| Precision | INT8 / INT32     |
| Mode      | Event-driven     |



SYSTEM_TOP.⁠

Fungsi Top-level sistem yang menghubungkan *sensor → AI → output fisik*.

 Fitur

•⁠  ⁠Integrasi sensor ultrasonik
•⁠  ⁠Preprocessing data
•⁠  ⁠Event-driven NN execution
•⁠  ⁠Output LED real-time

Spesifikasi Teknis

| Parameter | Nilai                  |
| --------- | ---------------------- |
| Clock     | 50 MHz                 |
| Sensor    | 4× HC-SR04             |
| Output    | 3 LED status           |
| Mode      | Event-driven inference |
| Target    | FPGA                   |





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
<img width="1280" height="620" alt="image" src="https://github.com/user-attachments/assets/be9cbdfc-0c3d-4a1e-bc86-a59c1f8481e9" />

Diagram tersebut menunjukkan alur kerja Finite State Machine (FSM) yang digunakan untuk mengatur proses pada Neural Network Accelerator. Sistem dimulai pada state IDLE, yaitu kondisi saat sistem masih menunggu dan belum melakukan pemrosesan. Jika sinyal reset (rst) aktif, sistem akan kembali ke state IDLE. Ketika proses dimulai, FSM berpindah ke state MAC_OP untuk menjalankan operasi perhitungan utama berupa multiply–accumulate.

Setelah satu proses MAC selesai, sistem berpindah ke state NEXT_IN untuk menyiapkan data input berikutnya, kemudian ke state NEXT_OUT untuk mengeluarkan atau menyimpan hasil sementara. Alur ini dapat berulang sesuai dengan jumlah data yang diproses. Setelah seluruh proses selesai, FSM masuk ke state FINISH dan dilanjutkan ke DONE_HOLD, di mana sinyal selesai dipertahankan sebagai penanda bahwa proses telah berakhir. Selanjutnya, sistem dapat kembali ke state IDLE untuk menunggu proses berikutnya.



hasil simulasi dan analisis
<img width="1508" height="764" alt="image" src="https://github.com/user-attachments/assets/fd6b0768-d54b-4f21-990b-fa52718ce7d5" />

Dari waveform simulasi yang ditampilkan, bisa dilihat kalau sistem berjalan sesuai dengan alur yang dirancang. Sinyal **clock (clk)** terlihat stabil sepanjang simulasi, yang menandakan sistem sinkron bekerja dengan baik. Di awal simulasi, **reset (rst)** aktif untuk menginisialisasi sistem, lalu dinonaktifkan agar rangkaian siap digunakan. Setelah itu, sinyal **start** diberikan sebentar sebagai tanda bahwa proses komputasi pada Neural Network Accelerator mulai dijalankan.

Nilai input **x0, x1, x2, dan x3** terlihat sudah stabil dengan nilai 13, 76, 24, dan 82 yang mewakili data dari sensor. Saat sinyal start aktif, sistem mulai melakukan proses klasifikasi berdasarkan data tersebut. Selama proses berlangsung, sinyal **done** masih bernilai rendah, artinya proses belum selesai. Di akhir simulasi, sinyal **done** berubah menjadi aktif dan nilai **class_id** muncul (bernilai 10) sebagai hasil klasifikasi. Hal ini menunjukkan bahwa sistem berhasil memproses input dan menghasilkan output sesuai dengan desain yang telah dibuat.







Lampiran (kode verilog)






link video implementasi
https://drive.google.com/file/d/1qvzWCa3wwLiYrUb09nVLZsgdOJ7CDhSX/view?usp=sharing


