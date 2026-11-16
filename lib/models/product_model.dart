class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String thumbnail;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? 'Produk',
      description: json['description'] ?? 'Deskripsi produk belum tersedia.',
      price: (json['price'] != null) ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
      rating: (json['rating'] != null) ? double.tryParse(json['rating'].toString()) ?? 0.0 : 0.0,
      stock: (json['stock'] != null) ? int.tryParse(json['stock'].toString()) ?? 0 : 0,
      brand: json['brand'] ?? 'Official Store',
      category: json['category'] ?? 'General',
      thumbnail: json['thumbnail'] ?? (json['images'] is List && (json['images'] as List).isNotEmpty ? json['images'][0] : ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'rating': rating,
      'stock': stock,
      'brand': brand,
      'category': category,
      'thumbnail': thumbnail,
    };
  }
}
