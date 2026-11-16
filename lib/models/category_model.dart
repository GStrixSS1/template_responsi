class CategoryModel {
  final String slug;
  final String name;
  final String iconName;

  CategoryModel({
    required this.slug,
    required this.name,
    required this.iconName,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      slug: json['slug'] ?? 'terbaru',
      name: json['name'] ?? 'Terbaru',
      iconName: json['iconName'] ?? 'newspaper',
    );
  }
}
