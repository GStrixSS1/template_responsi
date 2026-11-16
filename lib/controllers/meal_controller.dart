import 'package:get/get.dart';
import '../models/meal_model.dart';
import '../services/api_service.dart';

class MealController extends GetxController {
  final RxList<MealModel> meals = <MealModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxString selectedCategory = 'All'.obs;
  final RxString searchKeyword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMeals();
  }

  Future<void> fetchMeals() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final results = await ApiService.getMeals(
        category: selectedCategory.value,
        query: searchKeyword.value,
      );
      meals.assignAll(results);
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
      fetchMeals();
    }
  }

  void searchByName(String query) {
    searchKeyword.value = query;
    fetchMeals();
  }

  void clearSearch() {
    searchKeyword.value = '';
    fetchMeals();
  }
}

