// ============================================================================
// FILE: controllers/character_controller.dart
// ============================================================================
// FUNGSI FILE INI:
// Otak State Management (GetX) untuk halaman daftar data utama (List View).
// Mengontrol pengambilan data dari API, status loading, pesan error, filter, dan search.
//
// CARA MANGGIL CONTROLLER INI DARI VIEW (character_list_view.dart):
// 1. Ambil controller di View:
//      final CharacterController controller = Get.find<CharacterController>();
// 2. Pantau perubahan data secara reaktif menggunakan Obx:
//      Obx(() {
//        if (controller.isLoading.value) return CircularProgressIndicator();
//        return ListView.builder(
//          itemCount: controller.characters.length,
//          itemBuilder: (context, index) {
//            final item = controller.characters[index];
//            return Text(item.name); // <- Akses data di sini
//          },
//        );
//      })
// 3. Panggil method saat Search / Filter ditekan:
//      controller.searchByName(query);
//      controller.changeStatusFilter('Alive');
//      controller.fetchCharacters(); // untuk refresh
//
// PANDUAN RESPONSI:
// Jika tema ujian berbeda (misal Produk / Film):
// 1. Ganti nama class & model:
//      final RxList<ProductModel> products = <ProductModel>[].obs;
// 2. Panggil method ApiService yang sesuai:
//      final results = await ApiService.getProducts(...);
// ============================================================================

import 'package:get/get.dart';
import '../models/character_model.dart';
import '../services/api_service.dart';

class CharacterController extends GetxController {
  // 1. STATE REAKTIF (.obs)
  // List data utama yang ditampilkan di ListView UI
  final RxList<CharacterModel> characters = <CharacterModel>[].obs;

  // Indikator loading (true = tampilkan muter-muter / loading spinner)
  final RxBool isLoading = false.obs;

  // Pesan error jika gagal koneksi atau endpoint salah
  final RxString errorMessage = ''.obs;

  // State untuk filter dan search
  final RxString selectedStatus = 'All'.obs;
  final RxString searchKeyword = ''.obs;

  // onInit: Otomatis dijalankan saat pertama kali aplikasi dibuka
  @override
  void onInit() {
    super.onInit();
    fetchCharacters();
  }

  // ==========================================================================
  // METHOD: Mengambil data dari ApiService
  // ==========================================================================
  Future<void> fetchCharacters() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Panggil ApiService untuk request HTTP ke internet
      final results = await ApiService.getCharacters(
        status: selectedStatus.value,
        name: searchKeyword.value,
      );

      // assignAll: Mengganti isi list lama dengan data baru dari API
      characters.assignAll(results);
    } catch (e) {
      // Bersihkan teks exception agar pesan error di UI lebih rapi
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      // Matikan indikator loading
      isLoading.value = false;
    }
  }

  // ==========================================================================
  // METHOD: Ganti Filter Kategori / Status (Alive, Dead, Unknown, All)
  // Dipanggil saat ChoiceChip di UI ditekan
  // ==========================================================================
  void changeStatusFilter(String status) {
    if (selectedStatus.value != status) {
      selectedStatus.value = status;
      fetchCharacters(); // Ambil ulang data dengan filter baru
    }
  }

  // ==========================================================================
  // METHOD: Cari berdasarkan Nama
  // Dipanggil saat TextField search di UI berubah (onChanged)
  // ==========================================================================
  void searchByName(String query) {
    searchKeyword.value = query;
    fetchCharacters();
  }

  // ==========================================================================
  // METHOD: Bersihkan Pencarian (Clear Search)
  // ==========================================================================
  void clearSearch() {
    searchKeyword.value = '';
    fetchCharacters();
  }
}

