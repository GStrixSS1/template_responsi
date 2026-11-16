import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/favorite_controller.dart';
import '../../models/product_model.dart';
import '../../utils/app_theme.dart';

class ProductDetailView extends StatelessWidget {
  final ProductModel product;

  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.find<FavoriteController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: AppTheme.surface,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.background.withAlpha(180),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Get.back(),
            ),
            actions: [
              Obx(() {
                final isFav = favoriteController.isFavorite(product.id);
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.background.withAlpha(180),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.redAccent : Colors.white,
                      size: 26,
                    ),
                    onPressed: () => favoriteController.toggleFavorite(product),
                  ),
                );
              }),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    product.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.surfaceLight,
                      child: const Center(
                        child: Icon(Icons.shopping_bag, size: 64, color: AppTheme.textMuted),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withAlpha(50),
                            Colors.transparent,
                            AppTheme.background,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textLight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.secondary.withAlpha(40),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.secondary),
                        ),
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppTheme.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppTheme.star, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating} / 5.0',
                        style: const TextStyle(
                          color: AppTheme.star,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Brand: ${product.brand}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader('Deskripsi Produk'),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Detail Informasi'),
                  const SizedBox(height: 12),
                  _buildInfoTile(
                    icon: Icons.category_outlined,
                    title: 'Kategori Produk',
                    value: product.category,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoTile(
                    icon: Icons.inventory_2_outlined,
                    title: 'Stok Tersedia',
                    value: '${product.stock} unit',
                  ),
                  const SizedBox(height: 10),
                  _buildInfoTile(
                    icon: Icons.verified_outlined,
                    title: 'Brand / Merek',
                    value: product.brand,
                  ),
                  const SizedBox(height: 28),
                  Obx(() {
                    final isFav = favoriteController.isFavorite(product.id);
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFav ? Colors.redAccent : AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                        label: Text(
                          isFav ? 'Hapus dari Wishlist' : 'Tambah ke Wishlist Favorit',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => favoriteController.toggleFavorite(product),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textLight,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surfaceLight.withAlpha(160)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
