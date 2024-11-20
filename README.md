# TUGAS 9
# 1. Jelaskan mengapa kita perlu membuat model untuk melakukan pengambilan ataupun pengiriman data JSON? Apakah akan terjadi error jika kita tidak membuat model terlebih dahulu?
- Menggunakan Model :
    - Efisiensi parsing data : 
        Model memudahkan kita melakukan parsing data JSON, dengan cukup memanggil suatu metode saja untuk  mengonversi data JSON menjadi objek. Sebagai contoh, `ProductEntry.fromJson` 
    - Konsistensi dan validasi data JSON: 
        Model memastikan data yang diterima atau dikirim memiliki struktur yang konsisten. Sebagai contoh, `Fields` mendefinisikan bahwa `name` adalah `String` dan `price` adalah `int`. Jika server mengembalikan tipe data yang tidak sesuai, kita bisa detect error lebih dulu.
    - _Maintainability_
        - Lebih mudah dibaca dan dipahami
        - Dokumentasi struktut data lebih jelas
        - Perubahan struktur data lebih mudah ditrack
- Tidak Menggunakan Model :
    - Data JSON akan diproses sebagai `Map<String, dynamic>`.
    - Tidak ada pengecekan tipe data saat compile time
    - Menyebabkan runtime error jika ada kesalahan akses properti/tipe data

# 2. Jelaskan fungsi dari library http yang sudah kamu implementasikan pada tugas ini
- HTTP Request ke Server Django
    Library http digunakan untuk mengirimkan data dari aplikasi Flutter ke server Django melalui metode HTTP
    - POST: Mengirim data untuk login, register, atau logout.
    - GET: Untuk mengambil data dari server.
    Contoh: 
    ```
    @csrf_exempt
    def login(request):
        username = request.POST['username']
        password = request.POST['password']
    ```
    Data yang dikirimkan dari Flutter akan diolah oleh Django untuk verifikasi autentikasi akun user.
- Menerima dan Membaca Respon dari Server
    Setelah Django memproses request dari user, hasilnya akan dikirim kembali ke Flutter dalam bentuk JSON response. Nantinya pada Flutter, library http akan membaca response ini untuk menampilkan hasilnya kepada pengguna, misalnya lewat Snackbar atau Alert Dialog.
    Contoh: 
    1. Login Sukses:
        ```
        {
        "username": "indah",
        "status": true,
        "message": "Login sukses!"
        }
        ```
    2. Pesan response :
        ```
        if (response.statusCode == 200) {
            print(jsonDecode(response.body)['message']);
        } else {
            print(jsonDecode(response.body)['message']);
        }
        ```
- Parsing JSON Otomatis
    Library http dengan dart:convert digunakan untuk memproses data JSON yang dikirimkan Django, sehingga data dapat  digunakan dalam Flutter.
    Contoh : 
    ```
    final response = await http.get(Uri.parse('http://localhost:8000/products/'));
    if (response.statusCode == 200) {
        List<dynamic> products = jsonDecode(response.body);
        products.forEach((product) {
            print(product['name']);
        });
    }

    ```

# 3. Jelaskan fungsi dari CookieRequest dan jelaskan mengapa instance CookieRequest perlu untuk dibagikan ke semua komponen di aplikasi Flutter.
- Fungsi Utama `CookieRequest`: 
    - Manajemen Cookie
        - Menyimpan dan mengelola cookie dari server
        - Mempertahankan status autentikasi antar request
        - Menyimpan informasi sesi login
    - Persistensi Kredensial
        - Menyimpan token atau session ID
        - Memungkinkan user tetap login lintas halaman
        - Menghindari keharusan login berulang kali
    - Intercept HTTP Request
        - Menambahkan cookie ke setiap request
        - Memastikan request terautentikasi
        - Mengirim kredensial secara otomatis

- Mengapa `CookieRequest` Perlu Dibagikan ke Semua Komponen?
    - Konsistensi session
        Seluruh halaman menggunakan cookie yang sama, status login dapat dipertahakan di semua view, serta mencegah logout tidak sengaja.
    - Memudahkan akses data user
        Cookie berisi informasi terkait sesi pengguna, sehingga komponen yang memerlukan data ini dapat dengan mudah mengaksesnya.
    - Reaktivitas
        Ketika status sesi berubah misal login dan logout, seluruh komponen yang menggunakan `CookieRequest` dapat secara otomatis bereaksi terhadap perubahan ini.

# 4. Jelaskan mekanisme pengiriman data mulai dari input hingga dapat ditampilkan pada Flutter.
1. Input Data 
    Pengguna nantinya memberikan input data melalui Widget seperti TextField, maupun Button. Contoh : 
    ```
    child: TextFormField(
        decoration: InputDecoration(
            hintText: "Name",
            labelText: "Name",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
            ),
        ),
    )
    ```
2. Pengelolaan Data di Flutter
    - State Management, setelah data diterima berikutnya akan diolah atau disimpan di dalam variabel state management. Contoh `setState()` : 
    ```
    child: TextFormField(
        decoration: InputDecoration(
            hintText: "Name",
            labelText: "Name",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
            ),
        ),
        onChanged: (String? value) {
            setState(() {
                _name = value!;
            });
        },
    ),
    ```

    - Validasi Data, contoh : 
    ```
    validator: (String? value) {
        if (value == null || value.isEmpty) {
            return "Name cannot be empty!";
        }
        return null;
    },
    ```
3. Pengiriman Data 
    Data yang valid akan dikirim ke server menggunakan HTTP Request. Contoh : 
    ```
    onPressed: () async {
        if (_formKey.currentState!.validate()) {
            final response = await request.postJson(
                "http://localhost:8000/create-flutter/",
                jsonEncode(<String, String>{
                    'name': _name,
                    'price': _price.toString(),
                    'description': _description,
                    'stock': _stock.toString(),
                }),
            );
        }
    }
    ```
4. Pengolahan Data di Backend
    Setelah data diterima, backend memproses data sesuai kebutuhan dan memberikan respon dalam bentuk `JsonResponse`.

5. Menampilkan Data di Flutter
    Setelah data dari backend diterima, data diolah di Flutter menggunakan parsing dan selanjutnya ditampilkan pada Widget. Contoh : 
    ```
    Future<List<ProductEntry>> fetchProduct(CookieRequest request) async {
        //Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
        final response = await request.get('http://localhost:8000/json/');
        
        // Melakukan decode response menjadi bentuk json
        var data = response;
        
        // Melakukan konversi data json menjadi object ProductEntry
        List<ProductEntry> listProduct = [];
        for (var d in data) {
            if (d != null) {
                listProduct.add(ProductEntry.fromJson(d));
            }
        }
        return listProduct;
    }
    ```

# 5. Jelaskan mekanisme autentikasi dari login, register, hingga logout. Mulai dari input data akun pada Flutter ke Django hingga selesainya proses autentikasi oleh Django dan tampilnya menu pada Flutter.
1. Register
    - User nantinya akan mengisi form register pada Flutter
    - Data form yang di masukkan oleh user selanjutnya dikirim ke endpoint Django menggunakan HTTP POST
        ```
        final response = await request.postJson(
            "http://local:8000/auth/register/",
            jsonEncode({
                "username": username,
                "password1": password1,
                "password2": password2,
            }));
        ```
    - Django menerima data melalui endpoint /auth/register/.
    - Django memvalidasi data dari user
    - Jika valid dan berhasil, Flutter akan menampilkan pesan berhasil. Dan jika gagal, Flutter akan menampilkan pesan error.

2. Login
    - User mengisi form login di Flutter
    - FLutter mengirimkan data ke endpoint login Django menggunakan HTTP POST
        ```
        final response = await request
                .login("http://localhost:8000/auth/login/", {
            'username': username,
            'password': password,
        });

        if (request.loggedIn) {
            String message = response['message'];
            String uname = response['username'];
            if (context.mounted) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage()),
                );
                ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                        SnackBar(
                            content:
                                Text("$message Selamat datang, $uname.")),
                );
            }
        }
        ```
    - Jika username dan password valid, Django akan mengembalikan respons berisi pesan berhasil (message) dan informasi pengguna (username). Jika gagal, Django akan mengembalikan pesan error.
    - Setelah Django mengembalikan respons, Flutter memeriksa status login melalui `request.loggedIn`.
    - Jika login berhasil, Flutter akan mengambil respons message dan username yang nantinya akan di tampilkan dalam SnackBar menggunakan `ScaffoldMessenger`
    - Setelah itu, user akan di navigasi ke halaman utama `MyHomePage` menggunakan `Navigator.pushReplacement`.
    
3. Logout
    ```
    else if (item.name == "Logout") {
        final response = await request.logout(
            // Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
            "http://localhost:8000/auth/logout/");
        String message = response["message"];
        if (context.mounted) {
            if (response['status']) {
            String uname = response["username"];
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$message Sampai jumpa, $uname."),
            ));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
            );
            } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(message),
                ),
            );
            }
        }
    }
    ```
    - Ketika user memilih opsi Logout pada Flutter, Flutter akan mengirim permintaan logout ke server Django melalui fungsi `request.logout`.
    - Respons yang diterima dari server Django akan berisi beberapa informasi yaitu message dan username.
    - Django memproses logout dengan menghapus sesi atau token dan mengirimkan respons dengan status dan pesan.
    - Data nformasi nantinya akan ditampilkan dengan SnackBar sesuai status yang diterima.
    - Setelah logout berhasil, Flutter akan mengarahkan user ke halaman login menggunakan `Navigator.pushReplacement`.

# 6. Jelaskan bagaimana cara kamu mengimplementasikan checklist di atas secara step-by-step! (bukan hanya sekadar mengikuti tutorial).
- [ ]  Memastikan deployment proyek tugas Django kamu telah berjalan dengan baik.
    - Langkah pertama yang dilakukan, adalah membuat django-app bernama `authentication` pada project Django sebelumnya, dengan menjalankan :
        ```
        python manage.py startapp authentication
        ```
    - Selanjutnya, menambahkan `INSTALLED_APPS` pada `settings.py` yang ada di main project Django. 
    - Kemudian, install library dengan menjankan `pip install django-cors-headers`. Setelah terinstall tambahkan `django-cors-headers` ke `requirements.txt`.
    - Pada `INSTALLED_APPS`, kita tambahkan pula `corsheaders`. 
    - Tambahkan juga `corsheaders.middleware.CorsMiddleware` ke `MIDDLEWARE` yang ada pada Django 
    - Selanjutnya, pada settings.py yang ada di main project Django kita tambahkan 
        ```
        CORS_ALLOW_ALL_ORIGINS = True
        CORS_ALLOW_CREDENTIALS = True
        CSRF_COOKIE_SECURE = True
        SESSION_COOKIE_SECURE = True
        CSRF_COOKIE_SAMESITE = 'None'
        SESSION_COOKIE_SAMESITE = 'None'
        ```
    - Kemudian, kita buat metode view untuk login pada direktori `authentication` di file `views.py` yang berisikan code berikut : 
        ```
        from django.contrib.auth import authenticate, login as auth_login
        from django.http import JsonResponse
        from django.views.decorators.csrf import csrf_exempt

        @csrf_exempt
        def login(request):
            username = request.POST['username']
            password = request.POST['password']
            user = authenticate(username=username, password=password)
            if user is not None:
                if user.is_active:
                    auth_login(request, user)
                    # Status login sukses.
                    return JsonResponse({
                        "username": user.username,
                        "status": True,
                        "message": "Login sukses!"
                        # Tambahkan data lainnya jika ingin mengirim data ke Flutter.
                    }, status=200)
                else:
                    return JsonResponse({
                        "status": False,
                        "message": "Login gagal, akun dinonaktifkan."
                    }, status=401)

            else:
                return JsonResponse({
                    "status": False,
                    "message": "Login gagal, periksa kembali email atau kata sandi."
                }, status=401)
        ```
    - Selanjutnya kita buat file `urls.py` pada direktori `authentication`, dan tambahkan URL routingnya.

- [ ] Mengimplementasikan fitur registrasi akun pada proyek tugas Flutter.
    - Tambahkan terlebih dahulu metode register pada `authentication/views.py` yang ada pada Django.
        ```
        from django.contrib.auth.models import User
        import json
        @csrf_exempt
        def register(request):
            if request.method == 'POST':
                data = json.loads(request.body)
                username = data['username']
                password1 = data['password1']
                password2 = data['password2']

                # Check if the passwords match
                if password1 != password2:
                    return JsonResponse({
                        "status": False,
                        "message": "Passwords do not match."
                    }, status=400)
                
                # Check if the username is already taken
                if User.objects.filter(username=username).exists():
                    return JsonResponse({
                        "status": False,
                        "message": "Username already exists."
                    }, status=400)
                
                # Create the new user
                user = User.objects.create_user(username=username, password=password1)
                user.save()
                
                return JsonResponse({
                    "username": user.username,
                    "status": 'success',
                    "message": "User created successfully!"
                }, status=200)
            
            else:
                return JsonResponse({
                    "status": False,
                    "message": "Invalid request method."
                }, status=400)
        ```
    - Dan kita tambahkan path register ke dalam `authentication/urls.py` yang ada di Django.
    - Lalu pada proyek Flutter, kita buat berkas baru `register.dart` pada folder `screens`.
    - Pada `register.dart`, kita tambahkan code ini : 
        ```
        import 'dart:convert';
        import 'package:flutter/material.dart';
        import 'package:hoodie_yay/screens/login.dart';
        import 'package:pbp_django_auth/pbp_django_auth.dart';
        import 'package:provider/provider.dart';

        class RegisterPage extends StatefulWidget {
            const RegisterPage({super.key});

            @override
            State<RegisterPage> createState() => _RegisterPageState();
        }

        class _RegisterPageState extends State<RegisterPage> {
            final _usernameController = TextEditingController();
            final _passwordController = TextEditingController();
            final _confirmPasswordController = TextEditingController();

            @override
            Widget build(BuildContext context) {
                final request = context.watch<CookieRequest>();
                return Scaffold(
                appBar: AppBar(
                    title: const Text('Register'),
                    leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                        Navigator.pop(context);
                    },
                    ),
                ),
                body: Center(
                    child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                            const Text(
                                'Register',
                                style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                ),
                            ),
                            const SizedBox(height: 30.0),
                            TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                labelText: 'Username',
                                hintText: 'Enter your username',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                ),
                                validator: (value) {
                                if (value == null || value.isEmpty) {
                                    return 'Please enter your username';
                                }
                                return null;
                                },
                            ),
                            const SizedBox(height: 12.0),
                            TextFormField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                ),
                                obscureText: true,
                                validator: (value) {
                                if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                }
                                return null;
                                },
                            ),
                            const SizedBox(height: 12.0),
                            TextFormField(
                                controller: _confirmPasswordController,
                                decoration: const InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'Confirm your password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                ),
                                obscureText: true,
                                validator: (value) {
                                if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                }
                                return null;
                                },
                            ),
                            const SizedBox(height: 24.0),
                            ElevatedButton(
                                onPressed: () async {
                                String username = _usernameController.text;
                                String password1 = _passwordController.text;
                                String password2 = _confirmPasswordController.text;

                                // Cek kredensial
                                final response = await request.postJson(
                                    "http://local:8000/auth/register/",
                                    jsonEncode({
                                        "username": username,
                                        "password1": password1,
                                        "password2": password2,
                                    }));
                                if (context.mounted) {
                                    if (response['status'] == 'success') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                        content: Text('Successfully registered!'),
                                        ),
                                    );
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const LoginPage()),
                                    );
                                    } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                        content: Text('Failed to register!'),
                                        ),
                                    );
                                    }
                                }
                                },
                                style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 50),
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                ),
                                child: const Text('Register'),
                            ),
                            ],
                        ),
                        ),
                    ),
                    ),
                ),
                );
            }
        }
        ```
    

- [ ] Membuat halaman login pada proyek tugas Flutter.
    - Di dalam folder `screens`, kita tambahkan file `login.dart`.
    - Pada `login.dart`, kita tambahkan code berikut ini:
        ```
        import 'package:hoodie_yay/screens/menu.dart';
        import 'package:flutter/material.dart';
        import 'package:pbp_django_auth/pbp_django_auth.dart';
        import 'package:provider/provider.dart';
        import 'package:hoodie_yay/screens/register.dart';

        void main() {
            runApp(const LoginApp());
        }

        class LoginApp extends StatelessWidget {
            const LoginApp({super.key});

            @override
            Widget build(BuildContext context) {
                return MaterialApp(
                title: 'Login',
                theme: ThemeData(
                    useMaterial3: true,
                    colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.deepPurple,
                    ).copyWith(secondary: const Color(0xFF484C7F)),
                ),
                home: const LoginPage(),
                );
            }
        }

        class LoginPage extends StatefulWidget {
            const LoginPage({super.key});

            @override
            State<LoginPage> createState() => _LoginPageState();
        }

        class _LoginPageState extends State<LoginPage> {
            final TextEditingController _usernameController = TextEditingController();
            final TextEditingController _passwordController = TextEditingController();

            @override
            Widget build(BuildContext context) {
                final request = context.watch<CookieRequest>();

                return Scaffold(
                appBar: AppBar(
                    title: const Text('Login'),
                ),
                body: Center(
                    child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            const Text(
                                'Login',
                                style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                ),
                            ),
                            const SizedBox(height: 30.0),
                            TextField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                labelText: 'Username',
                                hintText: 'Enter your username',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                ),
                            ),
                            const SizedBox(height: 12.0),
                            TextField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                ),
                                obscureText: true,
                            ),
                            const SizedBox(height: 24.0),
                            ElevatedButton(
                                onPressed: () async {
                                String username = _usernameController.text;
                                String password = _passwordController.text;

                                // Cek kredensial
                                // Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                                // Untuk menyambungkan Android emulator dengan Django pada localhost,
                                // gunakan URL http://10.0.2.2/
                                final response = await request
                                    .login("http://localhost:8000/auth/login/", {
                                    'username': username,
                                    'password': password,
                                });

                                if (request.loggedIn) {
                                    String message = response['message'];
                                    String uname = response['username'];
                                    if (context.mounted) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyHomePage()),
                                    );
                                    ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("$message Selamat datang, $uname.")),
                                        );
                                    }
                                } else {
                                    if (context.mounted) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                        title: const Text('Login Gagal'),
                                        content: Text(response['message']),
                                        actions: [
                                            TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                                Navigator.pop(context);
                                            },
                                            ),
                                        ],
                                        ),
                                    );
                                    }
                                }
                                },
                                style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 50),
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                ),
                                child: const Text('Login'),
                            ),
                            const SizedBox(height: 36.0),
                            GestureDetector(
                                onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const RegisterPage()),
                                );
                                },
                                child: Text(
                                'Don\'t have an account? Register',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontSize: 16.0,
                                ),
                                ),
                            ),
                            ],
                        ),
                        ),
                    ),
                    ),
                ),
                );
            }
        }
        ```

- [ ] Mengintegrasikan sistem autentikasi Django dengan proyek tugas Flutter.
    - Menginstall package `flutter pub add provider` dan `flutter pub add pbp_django_auth`.
    - Modifikasi root widget yang ada di `main.dart` untuk menyediakan `CookieRequest` ke child widgets dengan menambahkan code :
        ```
        return Provider(
            create: (_) {
                CookieRequest request = CookieRequest();
                return request;
            },
        ),
        ```
    - Tambahkan pula `import 'package:pbp_django_auth/pbp_django_auth.dart';` dan `import 'package:provider/provider.dart';` pada `main.dart`.

- [ ] Membuat model kustom sesuai dengan proyek aplikasi Django.
    - Jalankan projek Django dengan cara `python manage.py runserver`.
    - Kemudian buka endpoint JSON "http://localhost:8000/json/"
    - Copy data JSON tersebut dan masukan ke situs web `Quicktype`.
    - Di dalam `Quicktype`, kita ubah setup namenya menjadi `ProductEntry` dan source typenya jadi `JSON` serta language nya menjadi `Dart`.
    - Lalu paste data JSON ke dalam textbox, hasil dari Quickytype kemudian kita copy.
    - Buat folder baru `models` pada subdirektori lib yang ada di Flutter
    - Kemudian buat file baru bernama `product_entry.dart`, code yang di dapat dari Quicktype tadi kita masukan pada file ini.

- [ ] Membuat halaman yang berisi daftar semua item yang terdapat pada endpoint JSON di Django yang telah kamu deploy.
    - [ ] Tampilkan name, price, dan description dari masing-masing item pada halaman ini.
        - Buat file baru pada direktori lib/screens dengan nama `list_productentry.dart`
        - Di dalam file ini, kita tambahkan impor library yang kita perlukan seperti : 
            ```
            import 'package:flutter/material.dart';
            import 'package:hoodie_yay/models/product_entry.dart';
            import 'package:hoodie_yay/widgets/left_drawer.dart';
            import 'package:pbp_django_auth/pbp_django_auth.dart';
            import 'package:provider/provider.dart';
            import 'package:hoodie_yay/screens/detail_product.dart';
            ```
        - Pada file ini kita tambahkan code berikut untuk menampilkan daftar item yang berisikan name, price, dan description.
            ```
            class ProductEntryPage extends StatefulWidget {
                const ProductEntryPage({super.key});

                @override
                State<ProductEntryPage> createState() => _ProductEntryPageState();
            }

            class _ProductEntryPageState extends State<ProductEntryPage> {
                Future<List<ProductEntry>> fetchProduct(CookieRequest request) async {
                    //Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                    final response = await request.get('http://localhost:8000/json/');
                    
                    // Melakukan decode response menjadi bentuk json
                    var data = response;
                    
                    // Melakukan konversi data json menjadi object ProductEntry
                    List<ProductEntry> listProduct = [];
                    for (var d in data) {
                    if (d != null) {
                        listProduct.add(ProductEntry.fromJson(d));
                    }
                    }
                    return listProduct;
                }

                @override
                Widget build(BuildContext context) {
                    final request = context.watch<CookieRequest>();
                    return Scaffold(
                    appBar: AppBar(
                        title: const Text('Product List'),
                    ),
                    drawer: const LeftDrawer(),
                    body: FutureBuilder(
                        future: fetchProduct(request),
                        builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                            return const Center(child: CircularProgressIndicator());
                        } else {
                            if (!snapshot.hasData) {
                            return const Column(
                                children: [
                                Text(
                                    'Belum ada data product pada Hoodie-Yay.',
                                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                                ),
                                SizedBox(height: 8),
                                ],
                            );
                            } else {
                            return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (_, index) => GestureDetector(
                                onTap: () {
                                    // Navigasi ke halaman detail ketika item ditekan
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetailPage(
                                        product: snapshot.data![index], // Mengirim data product
                                        ),
                                    ),
                                    );
                                },
                                child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    padding: const EdgeInsets.all(20.0),
                                    decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                        BoxShadow(
                                        color: const Color(0xFF484C7F).withOpacity(0.4),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                        ),
                                    ],
                                    ),
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                        "${snapshot.data![index].fields.name}",
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                        ),
                                        ),
                                        
                                        const SizedBox(height: 10),
                                        Text(
                                        "Price: ${snapshot.data![index].fields.price}",
                                        style: const TextStyle(fontSize: 14.0),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                        "Description: ${snapshot.data![index].fields.description}",
                                        style: const TextStyle(fontSize: 14.0),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                        "Stock: ${snapshot.data![index].fields.stock}",
                                        style: const TextStyle(fontSize: 14.0),
                                        ),
                                    ],
                                    ),
                                ),
                                ),
                            );
                            }
                        }
                        },
                    ),
                    );
                }
            }
            ```

- [ ] Membuat halaman detail untuk setiap item yang terdapat pada halaman daftar Item.
    - [ ] Halaman ini dapat diakses dengan menekan salah satu item pada halaman daftar Item.
    - [ ] Tampilkan seluruh atribut pada model item kamu pada halaman ini.
    - [ ] Tambahkan tombol untuk kembali ke halaman daftar item.

        - Kita buat file baru bernama `detail_product.dart` pada folder `screens`. 
        - Kemudian kita tambahkan code berikut ini untuk menampilkan detail tiap item
            ```
            import 'package:flutter/material.dart';
            import 'package:hoodie_yay/models/product_entry.dart';

            class ProductDetailPage extends StatelessWidget {
                final ProductEntry product;

                const ProductDetailPage({super.key, required this.product});

                @override
                Widget build(BuildContext context) {
                    return Scaffold(
                    appBar: AppBar(
                        title: const Text('Product Detail'),
                    ),
                    body: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                            product.fields.name,
                            style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                            ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                            "Price: ${product.fields.price}",
                            style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 10),
                            Text(
                            "Description: ${product.fields.description}",
                            style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 10),
                            Text(
                            "Stock: ${product.fields.stock}",
                            style: const TextStyle(fontSize: 14.0),
                            ),
                            const SizedBox(height: 20),
                        ],
                        ),
                    ),
                    );
                }
            }
            ```
            - Pada list_productentry kita tambahkan code ini untuk mengarahkan user ke detail_product page ketika mengklik
                ```
                else {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) => GestureDetector(
                            onTap: () {
                                // Navigasi ke halaman detail ketika item ditekan
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailPage(
                                    product: snapshot.data![index], // Mengirim data product
                                    ),
                                ),
                                );
                            },
                        ),
                    ),
                }
                ```

- [ ] Melakukan filter pada halaman daftar item dengan hanya menampilkan item yang terasosiasi dengan pengguna yang login.
    - Pada file `list_productentry.dart`, kita atur filter sehingga hanya menampilkan item yang terasosiasi dengan pengguna yang login, dengan menambahkan code berikut : 
        ```
        class _ProductEntryPageState extends State<ProductEntryPage> {
            Future<List<ProductEntry>> fetchProduct(CookieRequest request) async {
                final response = await request.get('http://localhost:8000/json/');
                
                // Melakukan decode response menjadi bentuk json
                var data = response;
                
                // Melakukan konversi data json menjadi object ProductEntry
                List<ProductEntry> listProduct = [];
                for (var d in data) {
                if (d != null) {
                    listProduct.add(ProductEntry.fromJson(d));
                }
                }
                return listProduct;
            }
        }
        ```


# TUGAS 8
## 1. Apa kegunaan const di Flutter? Jelaskan apa keuntungan ketika menggunakan const pada kode Flutter. Kapan sebaiknya kita menggunakan const, dan kapan sebaiknya tidak digunakan?
Di Flutter, `const` digunakan untuk mendeklarasikan objek yang bersifat konstan (immutable) dan ditentukan pada waktu kompilasi. Objek atau widget yang diberi label const akan dibuat hanya sekali dan digunakan kembali sepanjang siklus hidup aplikasi.

Kegunaan `const` di Flutter : 
- Optimasi Kinerja, `const` memungkinkan Flutter untuk menggunakan kembali objek, mengurangi pembuatan objek baru, dan meningkatkan kinerja.
- Peningkatan Keterbacaan dan Pemeliharaan, `const` membuat kode lebih mudah dipahami karena menandakan bahwa objek tidak akan diubah.
- Manajemen Pohon Widget yang Efisien, widget yang diberi label const hanya dibuat ulang jika referensinya berubah, dan mengurangi pembuatan ulang widget yang tidak perlu.
- Penyelarasan dengan Prinsip Pemrograman Fungsional, `const` mendukung konsep kekekalan dalam pemrograman fungsional, membuat kode lebih mudah dipahami dan diuji.

Kapan Sebaiknya Menggunakan `const`?
- Objek data yang tidak dapat diubah, `const` ideal untuk membuat objek data yang tidak dapat diubah seperti warna, konfigurasi, atau data apa pun yang tidak boleh berubah sepanjang siklus hidup aplikasi.
- Nilai yang telah ditetapkan sebelumnya, cocok untuk nilai statis atau titik akhir API yang tidak berubah.
- Mengoptimalkan pohon widget, `const` digunakan untuk menghindari pembuatan ulang widget yamg tidak perlu, sehingga dapat meningkatkan kinerja UI.

Kapan Sebaiknya Tidak Menggunakan `const`?
- Widget yang Dinamis, jangan gunakan const untuk widget yang nilainya bergantung pada perubahan data atau state. Widget ini akan berubah atau diperbarui selama siklus hidup aplikasi, sehingga tidak cocok menggunakan const.
- Widget yang Bergantung pada Parameter yang Berubah, jika sebuah widget menerima parameter yang dinamis, seperti yang diterima dari state atau hasil input pengguna, kita tidak bisa menggunakan `const` pada widget tersebut.


## 2. Jelaskan dan bandingkan penggunaan Column dan Row pada Flutter. Berikan contoh implementasi dari masing-masing layout widget ini!
Row dan column di Flutter digunakan untuk styling ke widget. Row dan column di Flutter dua widget yang penting yang dapat menyelaraskan widget secara horizontal atau vertikal sesuai kebutuhan aplikasi.

- Column 
    Widget column mengatur arah children di aplikasi. Column akan mengatur secara vertikal dari atas ke bawah. Widget ini berguna untuk membuat tata letak yang memerlukan elemen yang ditampilkan secara berururtan dalam satu column. 

    Column dapat diatur dengan menggunakan property `crossAxisAlignment` dan `mainAxisAlignment`. `crossAxisAlignment` digunakan untuk mengatur tata letak horizontal dari widget children. Sedangkan, `mainAxisAlignment` digunakan untuk mengatur tata letak vertikal dari widget children dalam column.

    Contoh implementasi : 
    ```
    child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                // Name Field
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Name",
                        labelText: "Name",
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        ),
                    ),
                    ),
                ), 
            ],
        ),
    ```

- Row 
    Widget Row mengatur arah children di aplikasi. Row akan mengatur secara horizontal dari kiri ke kanan. Widget ini digunakan untuk menampilkan elemen yang perlu berdampingan dalam satu baris.

    Sama dengan Column, Row widget diatur dengan menggunakan property `crossAxisAlignment` dan `mainAxisAlignment`. Row children widget dapat diatur dengan tambahan property `start`, `end`, `center`, `spaceBetween`, `spaceAround`, dan `spaceEvenly`.

    Contoh Implementasi : 
    ```
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            // Row untuk menampilkan 3 InfoCard secara horizontal.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'NPM', content: npm),
                InfoCard(title: 'Name', content: name),
                InfoCard(title: 'Class', content: className),
              ],
            ),
        ],
    ),
    ```

## 3. Sebutkan apa saja elemen input yang kamu gunakan pada halaman form yang kamu buat pada tugas kali ini. Apakah terdapat elemen input Flutter lain yang tidak kamu gunakan pada tugas ini? Jelaskan!
- Elemen input yang digunakan:
    - `TextFormField` - Digunakan untuk menerima input teks dari pengguna, seperti Name, Price, Stock, dan Description. TextFormField mendukung validasi input, sehingga bisa memastikan input pengguna sesuai kriteria yang telah ditentukan.
    - `ElevatedButton` - Tombol ini digunakan untuk menyimpan data yang telah diisi dalam form. ElevatedButton sebagai elemen input kontrol karena berfungsi sebagai pemicu aksi ketika ditekan.

- Elemen input yang tidak digunakan :
    - `Checkbox` - Digunakan untuk menerima pilihan true atau false.
    - `DropdownButton` - Digunakan untuk menyediakan daftar pilihan dalam bentuk dropdown. 
    - `Slider` - Elemen input ini memungkinkan pengguna memilih nilai numerik dengan cara menggeser.
    - `DatePicker` dan `TimePicker` - Berguna jika form membutuhkan input berupa tanggal atau waktu.
    - `Switch` - Mirip dengan Checkbox, namun dalam bentuk sakelar.

## 4. Bagaimana cara kamu mengatur tema (theme) dalam aplikasi Flutter agar aplikasi yang dibuat konsisten? Apakah kamu mengimplementasikan tema pada aplikasi yang kamu buat?
Pada `main.dart`, saya menambahkan code berikut di class `MyApp` untuk mengatur tema aplikasi,
    ```
    theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.pink,
        ).copyWith(secondary: const Color(0xFF484C7F)),
        useMaterial3: true,
      ),
    ```
Selanjutnya, saya terapkan warna theme ini di beberapa widget, seperti contoh :
- Pada `menu.dart` di class `MyHomePage` dan pada `productentry_form.dart` di class `_ProductEntryFormPageState`
    ```
    appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
    )
    ```
- Pada `left_drawer.dart` di class `LeftDrawer`
    ```
    decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
    ),
    ```

## 5. Bagaimana cara kamu menangani navigasi dalam aplikasi dengan banyak halaman pada Flutter?
- `productentry_form.dart` :
    ```
    actions: [
        TextButton(
            child: const Text('OK'),
            onPressed: () {
                Navigator.pop(context);
                _formKey.currentState!.reset();
            },
        ),
    ],
    ```
    Code ini mengatur action setelah pengguna click tombol 'OK'. Ketika tombol ditekan, ada dua hal yang terjadi:
        - `Navigator.pop(context)` digunakan untuk menutup halaman saat ini (pop halaman dari stack).
        - `_formKey.currentState!.reset()` akan mereset form untuk menghapus semua input yang telah diisi sebelumnya.

- `product_card.dart` :
    ```
    if (item.name == "Tambah Product") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProductEntryFormPage(),
            ),
        );
    }
    ```
    Jika `item.name` bernilai `"Tambah Product`", aplikasi akan menavigasi ke halaman `ProductEntryFormPage`. `Navigator.push`, akan menambahkan halaman baru ke dalam stack dan membuat halaman baru tersebut muncul di atas halaman sebelumnya.

- `left_drawer.dart` : 
    ```
    ListTile(
        leading: const Icon(Icons.home_outlined),
        title: const Text('Halaman Utama'),
        // Bagian redirection ke MyHomePage
        onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                )
            );
        },
    ),
    ```
    ```
    ListTile(
        leading: const Icon(Icons.inventory),
        title: const Text('Tambah Produk'),
        // Bagian redirection ke ProductEntryFormPage
        onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProductEntryFormPage(),
                ),
            );
        },
    ),
    ```
   `Navigator.pushReplacement` digunakan untuk menggantikan halaman saat ini dengan halaman tujuan, seperti MyHomePage atau ProductEntryFormPage. 
    - `MyHomePage`, saat user menekan `ListTile` dengan ikon "home", kode ini menggantikan halaman saat ini dengan` MyHomePage`.
    - `ProductEntryFormPage`, saat user memilih `ListTile` dengan ikon "inventory", aplikasi akan menggantikan halaman saat ini dengan halaman `ProductEntryFormPage`.


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
