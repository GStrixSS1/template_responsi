import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/meal_controller.dart';
import '../../controllers/favorite_controller.dart';
import '../../models/meal_model.dart';
import '../../utils/app_theme.dart';
import '../detail/meal_detail_view.dart';

class MealListView extends StatelessWidget {
  const MealListView({super.key});

  @override
  Widget build(BuildContext context) {
    final mealController = Get.find<MealController>();
    final favoriteController = Get.find<FavoriteController>();
    final searchController = TextEditingController(text: mealController.searchKeyword.value);

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
                    onSubmitted: (val) => mealController.searchByName(val),
                    decoration: InputDecoration(
                      hintText: 'Cari menu lezat (misal: Chicken, Rice)...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: Obx(() {
                        if (mealController.searchKeyword.value.isNotEmpty) {
                          return IconButton(
                            icon: const Icon(Icons.close, color: AppTheme.textMuted),
                            onPressed: () {
                              searchController.clear();
                              mealController.clearSearch();
                            },
                          );
                        }
                        return IconButton(
                          icon: const Icon(Icons.arrow_forward, color: AppTheme.primary),
                          onPressed: () => mealController.searchByName(searchController.text),
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
                          _buildFilterChip('All', mealController),
                          const SizedBox(width: 8),
                          _buildFilterChip('Seafood', mealController),
                          const SizedBox(width: 8),
                          _buildFilterChip('Chicken', mealController),
                          const SizedBox(width: 8),
                          _buildFilterChip('Beef', mealController),
                          const SizedBox(width: 8),
                          _buildFilterChip('Vegetarian', mealController),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (mealController.isLoading.value) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppTheme.primary),
                        SizedBox(height: 16),
                        Text(
                          'Menyiapkan hidangan lezat...',
                          style: TextStyle(color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  );
                }

                if (mealController.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 56, color: AppTheme.error),
                          const SizedBox(height: 12),
                          const Text(
                            'Gagal Memuat Menu',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            mealController.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => mealController.fetchMeals(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (mealController.meals.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.no_meals_outlined, size: 64, color: AppTheme.textMuted),
                          const SizedBox(height: 12),
                          const Text(
                            'Menu Tidak Ditemukan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Coba kata kunci pencarian makanan lain.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              searchController.clear();
                              mealController.clearSearch();
                              mealController.changeCategoryFilter('All');
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
                  onRefresh: () => mealController.fetchMeals(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: mealController.meals.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final meal = mealController.meals[index];
                      return _buildMealCard(context, meal, favoriteController);
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

  Widget _buildFilterChip(String value, MealController controller) {
    final isSelected = controller.selectedCategory.value.toLowerCase() == value.toLowerCase();

    return ChoiceChip(
      label: Text(value),
      selected: isSelected,
      selectedColor: AppTheme.primary,
      backgroundColor: AppTheme.surface,
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : AppTheme.textLight,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppTheme.primary : AppTheme.surfaceLight,
      ),
      onSelected: (_) => controller.changeCategoryFilter(value),
    );
  }

  Widget _buildMealCard(
    BuildContext context,
    MealModel meal,
    FavoriteController favoriteController,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Get.to(() => MealDetailView(meal: meal)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  meal.image,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 72,
                    height: 72,
                    color: AppTheme.surfaceLight,
                    child: const Icon(Icons.restaurant, color: AppTheme.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
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
                      '${meal.category} • ${meal.area}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Obx(() {
                final isFav = favoriteController.isFavorite(meal.id);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.redAccent : AppTheme.textMuted,
                    size: 24,
                  ),
                  onPressed: () => favoriteController.toggleFavorite(meal),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

