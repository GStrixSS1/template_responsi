import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/favorite_controller.dart';
import '../../models/product_model.dart';
import '../../utils/app_theme.dart';
import '../detail/product_detail_view.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.find<ProductController>();
    final favoriteController = Get.find<FavoriteController>();
    final searchController = TextEditingController(text: productController.searchKeyword.value);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    style: const TextStyle(color: AppTheme.textLight),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (val) => productController.searchByTitle(val),
                    decoration: InputDecoration(
                      hintText: 'Cari produk (misal: iPhone, Perfume)...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: Obx(() {
                        if (productController.searchKeyword.value.isNotEmpty) {
                          return IconButton(
                            icon: const Icon(Icons.close, color: AppTheme.textMuted),
                            onPressed: () {
                              searchController.clear();
                              productController.clearSearch();
                            },
                          );
                        }
                        return IconButton(
                          icon: const Icon(Icons.arrow_forward, color: AppTheme.primary),
                          onPressed: () => productController.searchByTitle(searchController.text),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(
                      () => Row(
                        children: [
                          _buildFilterChip('All', productController),
                          const SizedBox(width: 8),
                          _buildFilterChip('beauty', productController, label: 'Beauty'),
                          const SizedBox(width: 8),
                          _buildFilterChip('fragrances', productController, label: 'Parfum'),
                          const SizedBox(width: 8),
                          _buildFilterChip('furniture', productController, label: 'Furniture'),
                          const SizedBox(width: 8),
                          _buildFilterChip('groceries', productController, label: 'Groceries'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (productController.isLoading.value) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppTheme.primary),
                        SizedBox(height: 16),
                        Text(
                          'Memuat katalog belanja...',
                          style: TextStyle(color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  );
                }

                if (productController.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 56, color: AppTheme.error),
                          const SizedBox(height: 12),
                          const Text(
                            'Gagal Memuat Produk',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            productController.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => productController.fetchProducts(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (productController.products.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.production_quantity_limits, size: 64, color: AppTheme.textMuted),
                          const SizedBox(height: 12),
                          const Text(
                            'Produk Tidak Ditemukan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Coba ubah kata kunci atau ganti filter kategori.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              searchController.clear();
                              productController.clearSearch();
                              productController.changeCategoryFilter('All');
                            },
                            child: const Text('Reset Filter & Pencarian'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppTheme.primary,
                  backgroundColor: AppTheme.surface,
                  onRefresh: () => productController.fetchProducts(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: productController.products.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final product = productController.products[index];
                      return _buildProductCard(context, product, favoriteController);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, ProductController controller, {String? label}) {
    final isSelected = controller.selectedCategory.value.toLowerCase() == value.toLowerCase();
    final displayLabel = label ?? value;

    return ChoiceChip(
      label: Text(displayLabel),
      selected: isSelected,
      selectedColor: AppTheme.primary,
      backgroundColor: AppTheme.surface,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppTheme.textLight,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppTheme.primary : AppTheme.surfaceLight,
      ),
      onSelected: (_) => controller.changeCategoryFilter(value),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    ProductModel product,
    FavoriteController favoriteController,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Get.to(() => ProductDetailView(product: product)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.thumbnail,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 72,
                    height: 72,
                    color: AppTheme.surfaceLight,
                    child: const Icon(Icons.shopping_bag, color: AppTheme.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product.price.toStringAsFixed(2)} • ${product.category}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.secondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppTheme.star, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.star,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Stok: ${product.stock}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Obx(() {
                final isFav = favoriteController.isFavorite(product.id);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.redAccent : AppTheme.textMuted,
                    size: 24,
                  ),
                  onPressed: () => favoriteController.toggleFavorite(product),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
