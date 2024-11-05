# TUGAS 7
# 1. Jelaskan apa yang dimaksud dengan stateless widget dan stateful widget, dan jelaskan perbedaan dari keduanya.
*Stateless widget* adalah widget statis dimana seluruh konfigurasi yang dimuat didalamnya telah diinisiasi sejak awal, dan cocok untuk tampilan yang tidak memerlukan pembaruan seperti teks atau ikon. Sedangkan *Stateful widget*  bersifat dinamis dan dapat memperbarui tampilannya berdasarkan perubahan data atau interaksi pengguna, menjadikannya ideal untuk elemen UI yang membutuhkan pembaruan real-time seperti form input atau animasi.

Perbedaan utama antara kedua widget ini terletak pada kemampuannya mengelola state, stateless widget lebih sederhana tanpa state yang bisa berubah, sedangkan stateful widget memiliki mekanisme pengelolaan state yang lebih kompleks untuk mendukung interaktivitas yang dinamis. Stateless widget hanya memiliki `build()` method yang dipanggil sekali saat widget dirender pertama kali, sedangkan stateful widget memiliki lifecycle yang lebih kompleks, seperti `initState()`, `setState()`, `dispose()`, dll, yang mengatur bagaimana widget merespons perubahan dan mengelola status.

# 2. Sebutkan widget apa saja yang kamu gunakan pada proyek ini dan jelaskan fungsinya.
    - MaterialApp : Sebagai titik awal untuk aplikasi di Flutter, yang menyediakan konfigurasi global seperti theme dan title aplikasi.
    - Scaffold :  Menyediakan struktur dasar untuk sebuah halaman, seperti elemen-elemen utama seperti AppBar dan body.
    - AppBar : Digunakan untuk menampilkan bagian atas halaman.
    - Padding : Digunakan untuk menambahkan jarak di sekeliling atau di dalam widget, seperti nambah ruang antar kolom pada teks “Welcome to Hoodie-Yay!”.
    - Column : Menyusun child secara vertikal, seperti menyusun InfoCard dan GridView dalam satu kolom vertikal.
    - Row : Menyusun child secara horizontal, seperti untuk menampilkan InfoCard untuk NPM, nama, dan kelas secara sejajar dalam satu baris.
    - GridView.count : Membuat tata letak grid dengan jumlah kolom yang ditentukan, seperti menampilkan ItemCard dalam bentuk grid dengan 3 kolom.
    - Card : Menampilkan konten dengan bayangan (elevation), digunakan pada InfoCard untuk menampilkan NPM, nama, dan kelas.
    - Container : Menyediakan fitur styling, seperti pada InfoCard dan ItemCard untuk menata ukuran dan jarak dalam card.
    - Text : Digunakan untuk  menampilkan teks, seperti judul, konten, dan label dari elemen-elemen seperti InfoCard dan ItemCard.
    - Icon : Menampilkan ikon untuk memberikan indikasi visual dari fungsi atau tipe informasi yang ditampilkan, seperti list, add, dan logout di ItemCard. 
    - InkWell : Menambahkan efek visual saat widget ditekan, digunakan untuk menangani tap pada ItemCard dan menampilkan SnackBar saat tombol ditekan.
    - SnackBar : Menampilkan pesan sementara di bagian bawah layar, seperti saat ItemCard ditekan, SnackBar akan muncul sebagai feedback kepada pengguna.

# 3. Apa fungsi dari setState()? Jelaskan variabel apa saja yang dapat terdampak dengan fungsi tersebut.
Fungsi `setState()` dalam Flutter berfungsi untuk memberi tahu framework bahwa ada perubahan pada data aplikasi yang memerlukan pembaruan tampilan (UI) secara langsung. Dengan dipanggilnya `setState()`, framework akan merender ulang komponen yang terdampak, sehingga dapat menanpilkan data yang sesuai.

Dalam StatefulWidget, `setState()` digunakan untuk memperbaharui variable yang di declare dalam state class, seperti : 
- Instance atau Member Variables dalam State Class, variabel ini menyimpan data atau status sementara yang digunakan untuk menampilkan UI dan akan diperbarui saat pengguna berinteraksi atau saat terjadi perubahan tertentu.
- Collections (List, Map, Set), kemungkinan berubah seiring waktu, baik melalui penambahan, penghapusan, atau modifikasi item di dalamnya.
- Custom Objects atau Classes, objek atau kelas yang dibuat khusus, menyimpan data atau status aplikasi yang mungkin perlu diperbarui berdasarkan kondisi tertentu.

# 4. Jelaskan perbedaan antara const dengan final.
`const:`
- Digunakan untuk variabel atau objek yang nilainya sudah diketahui pada saat compile-time dan tidak akan berubah sama sekali.
- Objek yang dibuat dengan `const` bersifat immutable (tidak dapat diubah) sepenuhnya, termasuk semua atribut di dalamnya.
- `const` juga dapat digunakan untuk membuat objek konstan yang bersifat global.

`final:`
- Digunakan untuk variabel yang nilainya hanya akan ditetapkan sekali, tetapi baru diketahui pada saat run-time.
- Variabel atau objek `final` hanya dapat diinisialisasi sekali, tetapi objek itu sendiri bisa berisi atribut yang bisa diubah.
- `final` cocok untuk nilai yang ditentukan sekali saja pada saat aplikasi berjalan.

# 5. Jelaskan bagaimana cara kamu mengimplementasikan checklist-checklist di atas.
- [ ] Membuat sebuah program Flutter baru dengan tema E-Commerce yang sesuai dengan tugas-tugas sebelumnya.
    - Melakukan instalasi flutter.
    - Kemudian, install IDE (VS Code) lalu install extension Dart dan Flutter di dalammya.
    - Selanjutnya, buka terminal di direktori tempat penyimpanan proyek yang diinginkan lalu jalankan perintah:
        ```
        flutter create hoodie_yay
        cd hoodie_yay
        ```
    - Lalu, jalankan proyek lalu pilih browser yang diinginkan untuk menampilkan app dengan menjalankan perintah `flutter run`.
    - Jika proyek sudah berjalan, inisiasi repositori baru dalam github lalu add, commit, dan push proyek flutter tersebut.

- [ ] Membuat tiga tombol sederhana dengan ikon dan teks untuk:
    - Pertama kita buat class baru bernama `ItemHomePage` yang berisi atribut-atribut seperti name, icon, dan color.
        ```
        class ItemHomepage {
            final String name;
            final IconData icon;
            final Color color;

            ItemHomepage(this.name, this.icon, this.color);
        }
        ```
    - Lalu, kita buat class MyHomePage extends StatelessWidget, lalu kita buat list of ItemHomePage yang berisi tombol-tombol berikut : 
        - Lihat Daftar Produk
        - Tambah Produk
        - Logout
        ```
        class MyHomePage extends StatelessWidget {
            final List<ItemHomepage> items = [
            ItemHomepage("Lihat Daftar Produk", Icons.list, const Color(0xFFAC8DAF)),
            ItemHomepage("Tambah Produk", Icons.add, const Color(0xFFDDB6C6)),
            ItemHomepage("Logout", Icons.logout, const Color(0xFFF1D4D4)),
            ];
        }
        ```
    - Selanjutnya, kita tampilkan ketiga tombol tersebut dalam bentuk grid, yang diatur dalam `MyHomePage`, dengan mengunakan `GridView.count`. 
        ```
        // Grid untuk menampilkan ItemCard dalam bentuk grid 3 kolom.
        GridView.count(
            primary: true,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            // Agar grid menyesuaikan tinggi kontennya.
            shrinkWrap: true,

            // Menampilkan ItemCard untuk setiap item dalam list items.
            children: items.map((ItemHomepage item) {
                return ItemCard(item);
            }).toList(),
        ),
        ```

- [ ] Mengimplementasikan warna-warna yang berbeda untuk setiap tombol (Lihat Daftar Produk, Tambah Produk, dan Logout).
    - Di dalam class `MyHomePage`, terdapat button-button yang sudah kita buat sebelumnya di list `ItemHomePage`, masing-masing button ini kita tentukan warna yang berbeda di parameter color yang kita sudah inisialisasi di `class ItemHomepage` sebelumnya. 
        ```
        final List<ItemHomepage> items = [
            ItemHomepage("Lihat Daftar Produk", Icons.list, const Color(0xFFAC8DAF)), // Warna ungu muda
            ItemHomepage("Tambah Produk", Icons.add, const Color(0xFFDDB6C6)),        // Warna merah muda
            ItemHomepage("Logout", Icons.logout, const Color(0xFFF1D4D4)),            // Warna pink terang
        ];
        ```
        - Color(0xFFAC8DAF) untuk warna tombol "Lihat Daftar Produk."
        - Color(0xFFDDB6C6) untuk warna tombol "Tambah Produk."
        - Color(0xFFF1D4D4) untuk warna tombol "Logout."

- [ ] Memunculkan Snackbar dengan tulisan:
    - [ ] "Kamu telah menekan tombol Lihat Daftar Produk" ketika tombol Lihat Daftar Produk ditekan.
    - [ ] "Kamu telah menekan tombol Tambah Produk" ketika tombol Tambah Produk ditekan.
    - [ ] "Kamu telah menekan tombol Logout" ketika tombol Logout ditekan.

       - Di dalam class `ItemCard`, kita tambahkan `onTap` pada wisget `InkWell` yang menangkap aksi ketika tombol ditekan.
       - Pada `onTap`, kita gunakan item.name untuk menyesuaikan pesan yang muncul di SnackBar berdasarkan tombol yang ditekan.
       ```
        child: InkWell(
            // Aksi ketika kartu ditekan.
            onTap: () {
                // Menampilkan pesan SnackBar saat kartu ditekan.
                ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!"))
                );
            },
            // Container untuk menyimpan Icon dan Text
            child: Container(
                // ...
            ),
        ),
       ```
       - `${item.name}` akan secara otomatis diganti dengan nama tombol yang ditekan, sehingga SnackBar yang ditampilkan akan sesuai dengan tombol yang ditekan pula.
