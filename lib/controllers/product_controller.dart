import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxString selectedCategory = 'all'.obs;
  final RxString searchKeyword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchProducts();
  }

  Future<void> fetchCategories() async {
    try {
      final list = await ApiService.getCategories();
      categories.assignAll(list);
    } catch (_) {}
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final results = await ApiService.getProducts(
        category: selectedCategory.value,
        query: searchKeyword.value,
      );
      products.assignAll(results);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void filterByCategory(String category) {
    if (selectedCategory.value != category) {
      selectedCategory.value = category;
      searchKeyword.value = '';
      fetchProducts();
    }
  }

  void searchProducts(String query) {
    searchKeyword.value = query;
    fetchProducts();
  }

  void clearSearch() {
    searchKeyword.value = '';
    fetchProducts();
  }
}

