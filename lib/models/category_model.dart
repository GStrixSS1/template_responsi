class CategoryModel {
  final String slug;
  final String name;

  CategoryModel({
    required this.slug,
    required this.name,
  });

  factory CategoryModel.fromJson(dynamic json) {
    if (json is Map) {
      return CategoryModel(
        slug: json['slug'] ?? json['name'] ?? '',
        name: json['name'] ?? json['slug'] ?? 'Kategori',
      );
    } else {
      final str = json.toString();
      final capitalized = str.isNotEmpty ? '${str[0].toUpperCase()}${str.substring(1)}' : str;
      return CategoryModel(
        slug: str,
        name: capitalized,
      );
    }
  }
}
