import 'package:get/get.dart';
import '../models/movie_model.dart';
import '../services/api_service.dart';

class MovieController extends GetxController {
  final RxList<MovieModel> movies = <MovieModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxString selectedStatus = 'All'.obs;
  final RxString searchKeyword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final results = await ApiService.getMovies(
        status: selectedStatus.value,
        name: searchKeyword.value,
      );
      movies.assignAll(results);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void changeStatusFilter(String status) {
    if (selectedStatus.value != status) {
      selectedStatus.value = status;
      fetchMovies();
    }
  }

  void searchByName(String query) {
    searchKeyword.value = query;
    fetchMovies();
  }

  void clearSearch() {
    searchKeyword.value = '';
    fetchMovies();
  }
}

