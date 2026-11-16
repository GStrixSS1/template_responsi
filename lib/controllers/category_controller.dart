import 'package:get/get.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class CategoryController extends GetxController {
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    try {
      final results = await ApiService.getCategories();
      categories.assignAll(results);
    } finally {
      isLoading.value = false;
    }
  }
}
