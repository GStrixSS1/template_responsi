class MealModel {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String image;

  MealModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.image,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['idMeal']?.toString() ?? json['id']?.toString() ?? '0',
      name: json['strMeal'] ?? json['name'] ?? 'Menu Makanan',
      category: json['strCategory'] ?? json['category'] ?? 'Spesial',
      area: json['strArea'] ?? json['area'] ?? 'Kuliner Nusantara',
      instructions: json['strInstructions'] ?? json['instructions'] ?? 'Resep dan panduan memasak istimewa.',
      image: json['strMealThumb'] ?? json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'area': area,
      'instructions': instructions,
      'image': image,
    };
  }
}

