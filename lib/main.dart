// ============================================================================
// FILE: main.dart
// ============================================================================
// FUNGSI FILE INI:
// Titik masuk utama (Entry Point) dari seluruh aplikasi Flutter.
// Melakukan inisialisasi awal database lokal (Hive), session (SharedPreferences),
// dependency injection controller (GetX), dan routing halaman awal.
//
// ALUR INISIALISASI (STEP BY STEP):
// 1. WidgetsFlutterBinding.ensureInitialized():
//      Wajib dipanggil karena kita menjalankan operasi async (await) sebelum runApp().
// 2. Hive.initFlutter():
//      Menyiapkan folder penyimpanan database lokal Hive di penyimpanan HP/Emulator.
// 3. Hive.registerAdapter(UserModelAdapter()):
//      Mendaftarkan adapter biner agar Hive tahu cara membaca & menulis objek UserModel.
// 4. Hive.openBox<UserModel>(AuthService.userBoxName):
//      Membuka file database 'users_box' agar siap dipakai untuk Register & Login.
// 5. AuthService.seedDefaultUserIfEmpty():
//      Membuat akun bawaan 'admin' / 'admin123' secara otomatis jika box masih kosong.
// 6. AuthService.isUserLoggedIn():
//      Mengecek status login di SharedPreferences. Jika bernilai true -> langsung masuk ke MainNavView.
// 7. Get.put(...):
//      Dependency Injection GetX agar Controller bisa dipanggil di halaman manapun via Get.find<...>().
// 8. GetMaterialApp:
//      Pengganti MaterialApp bawaan agar fitur Get.to(), Get.snackbar(), dan Get.dialog() berfungsi.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'controllers/auth_controller.dart';
import 'controllers/character_controller.dart';
import 'controllers/episode_controller.dart';
import 'controllers/favorite_controller.dart';
import 'models/user_model.dart';
import 'services/auth_service.dart';
import 'utils/app_theme.dart';
import 'views/auth/login_view.dart';
import 'views/home/main_nav_view.dart';

void main() async {
  // 1. Wajib ada sebelum menjalankan async di main
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Database Lokal Hive
  await Hive.initFlutter();

  // 3. Daftarkan Adapter UserModel (dari models/user_model.dart)
  Hive.registerAdapter(UserModelAdapter());

  // 4. Buka Box database user
  await Hive.openBox<UserModel>(AuthService.userBoxName);

  // 5. Buat user default (admin / admin123) untuk demo cepat ke Aslab
  await AuthService.seedDefaultUserIfEmpty();

  // 6. Cek apakah user sebelumnya sudah login (dari SharedPreferences)
  final isUserLoggedIn = await AuthService.isUserLoggedIn();

  // 7. Jalankan aplikasi Flutter
  runApp(RickAndMortyApp(isLoggedIn: isUserLoggedIn));
}

class RickAndMortyApp extends StatelessWidget {
  final bool isLoggedIn;

  const RickAndMortyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    // DEPENDENCY INJECTION GETX (GET.PUT):
    // Dengan mendaftarkan controller di sini, kita bisa memanggilnya di file manapun
    // cukup dengan: Get.find<NamaController>()
    Get.put(AuthController());
    Get.put(FavoriteController());
    Get.put(CharacterController());
    Get.put(EpisodeController());

    // Gunakan GetMaterialApp (BUKAN MaterialApp) agar routing GetX & Snackbar berfungsi!
    return GetMaterialApp(
      title: 'Rick & Morty Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      // Jika session sudah aktif -> Buka halaman Home (MainNavView)
      // Jika belum login -> Buka halaman Login (LoginView)
      home: isLoggedIn ? const MainNavView() : const LoginView(),
    );
  }
}
