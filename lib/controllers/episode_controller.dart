// ============================================================================
// FILE: controllers/episode_controller.dart
// ============================================================================
// FUNGSI FILE INI:
// Controller untuk data sekunder (contoh: Episode, Jadwal, atau Kategori).
//
// CARA MANGGIL CONTROLLER INI DARI VIEW (episode_list_view.dart):
// 1. Ambil controller:
//      final EpisodeController controller = Get.find<EpisodeController>();
// 2. Tampilkan list dengan Obx:
//      Obx(() => ListView.builder(
//        itemCount: controller.episodes.length,
//        itemBuilder: (context, index) {
//          final ep = controller.episodes[index];
//          return ListTile(title: Text(ep.name), subtitle: Text(ep.airDate));
//        },
//      ))
// ============================================================================

import 'package:get/get.dart';
import '../models/episode_model.dart';
import '../services/api_service.dart';

class EpisodeController extends GetxController {
  final RxList<EpisodeModel> episodes = <EpisodeModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEpisodes();
  }

  // Mengambil daftar episode dari ApiService
  Future<void> fetchEpisodes() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final results = await ApiService.getEpisodes();
      episodes.assignAll(results);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}

