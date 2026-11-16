import 'package:get/get.dart';
import '../models/news_model.dart';
import '../services/api_service.dart';

class NewsController extends GetxController {
  final RxList<NewsModel> newsList = <NewsModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxString selectedCategory = 'terbaru'.obs;
  final RxString searchKeyword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  Future<void> fetchNews() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final results = await ApiService.getNews(
        category: selectedCategory.value,
        query: searchKeyword.value,
      );
      newsList.assignAll(results);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void changeCategoryFilter(String category) {
    if (selectedCategory.value != category) {
      selectedCategory.value = category;
      searchKeyword.value = '';
      fetchNews();
    }
  }

  void searchByKeyword(String query) {
    searchKeyword.value = query;
    fetchNews();
  }

  void clearSearch() {
    searchKeyword.value = '';
    fetchNews();
  }
}
