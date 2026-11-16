import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxString selectedCategory = 'All'.obs;
  final RxString searchKeyword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
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

  void changeCategoryFilter(String category) {
    if (selectedCategory.value != category) {
      selectedCategory.value = category;
      searchKeyword.value = '';
      fetchProducts();
    }
  }

  void searchByTitle(String query) {
    searchKeyword.value = query;
    fetchProducts();
  }

  void clearSearch() {
    searchKeyword.value = '';
    fetchProducts();
  }
}
