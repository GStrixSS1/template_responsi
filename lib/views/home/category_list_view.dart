import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/category_controller.dart';
import '../../models/category_model.dart';
import '../../utils/app_theme.dart';

class CategoryListView extends StatelessWidget {
  final Function(String slug)? onSelectCategory;

  const CategoryListView({super.key, this.onSelectCategory});

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'policy':
        return Icons.policy_outlined;
      case 'gavel':
        return Icons.gavel_outlined;
      case 'trending_up':
        return Icons.trending_up;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'directions_car':
        return Icons.directions_car_outlined;
      case 'movie':
        return Icons.movie_creation_outlined;
      case 'newspaper':
      default:
        return Icons.newspaper_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController = Get.find<CategoryController>();

    return Obx(() {
      if (categoryController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryRed),
        );
      }

      if (categoryController.categories.isEmpty) {
        return const Center(
          child: Text(
            'Kategori tidak tersedia',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categoryController.categories.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final cat = categoryController.categories[index];
          return _buildCategoryTile(context, cat);
        },
      );
    });
  }

  Widget _buildCategoryTile(BuildContext context, CategoryModel cat) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppTheme.primaryRed.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getIconData(cat.iconName),
            color: AppTheme.primaryRed,
          ),
        ),
        title: Text(
          cat.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          'Kanal Berita Antara / ${cat.slug}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: () {
          if (onSelectCategory != null) {
            onSelectCategory!(cat.slug);
          }
        },
      ),
    );
  }
}
