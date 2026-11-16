import 'package:get/get.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';

class CategoryController extends GetxController {
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final results = await ApiService.getCategories();
      categories.assignAll(results);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}
