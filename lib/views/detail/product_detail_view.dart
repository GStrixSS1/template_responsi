import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/favorite_controller.dart';
import '../../models/product_model.dart';
import '../../services/api_service.dart';
import '../../utils/app_theme.dart';

class ProductDetailView extends StatefulWidget {
  final ProductModel product;

  const ProductDetailView({super.key, required this.product});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final FavoriteController _favoriteController = Get.find<FavoriteController>();
  late ProductModel _currentProduct;
  bool _isLoadingDetail = false;

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.product;
    _fetchDetailFromApi();
  }

  Future<void> _fetchDetailFromApi() async {
    setState(() {
      _isLoadingDetail = true;
    });

    try {
      final freshDetail = await ApiService.getProductDetail(widget.product.id);
      if (mounted) {
        setState(() {
          _currentProduct = freshDetail;
        });
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingDetail = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          Obx(() {
            final isWish = _favoriteController.isWishlist(_currentProduct.id);
            return IconButton(
              tooltip: isWish ? 'Hapus dari Wishlist' : 'Tambah ke Wishlist',
              icon: Icon(
                isWish ? Icons.favorite : Icons.favorite_border,
                color: isWish ? Colors.redAccent : Colors.white,
              ),
              onPressed: () {
                _favoriteController.toggleWishlist(_currentProduct);
              },
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  color: Colors.white,
                  child: _currentProduct.thumbnail.isNotEmpty
                      ? Image.network(
                          _currentProduct.thumbnail,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Center(
                            child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                          ),
                        )
                      : const Center(
                          child: Icon(Icons.shopping_bag, size: 64, color: AppTheme.primary),
                        ),
                ),
                if (_isLoadingDetail)
                  const Positioned(
                    top: 12,
                    right: 12,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary),
                    ),
                  ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _currentProduct.category.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (_currentProduct.discountPercentage > 0)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.danger,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Diskon ${_currentProduct.discountPercentage.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentProduct.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '\$${_currentProduct.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.secondary.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.secondary.withAlpha(100)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: AppTheme.secondary, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              _currentProduct.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const Text(
                              ' / 5.0',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'Informasi Produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    icon: Icons.category_outlined,
                    label: 'Kategori',
                    value: _currentProduct.category,
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.branding_watermark_outlined,
                    label: 'Brand',
                    value: _currentProduct.brand.isNotEmpty ? _currentProduct.brand : 'Tersedia / Umum',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.inventory_2_outlined,
                    label: 'Informasi Stok',
                    value: '${_currentProduct.stock} unit tersedia',
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    icon: Icons.local_offer_outlined,
                    label: 'Persentase Diskon',
                    value: '${_currentProduct.discountPercentage.toStringAsFixed(2)}%',
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentProduct.description.isNotEmpty
                        ? _currentProduct.description
                        : 'Tidak ada deskripsi tambahan.',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textMuted,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Obx(() {
                    final isWish = _favoriteController.isWishlist(_currentProduct.id);
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isWish ? AppTheme.danger : AppTheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(
                          isWish ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                        label: Text(
                          isWish ? 'Hapus dari Wishlist' : 'Tambah ke Wishlist',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          _favoriteController.toggleWishlist(_currentProduct);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primary),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textMuted,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

