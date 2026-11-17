import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';

  static Future<List<ProductModel>> getProducts({
    String? category,
    String? query,
  }) async {
    Uri uri;

    if (query != null && query.trim().isNotEmpty) {
      uri = Uri.parse('$baseUrl/products/search?q=${Uri.encodeComponent(query.trim())}');
    } else if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
      uri = Uri.parse('$baseUrl/products/category/${Uri.encodeComponent(category.toLowerCase())}');
    } else {
      uri = Uri.parse('$baseUrl/products?limit=100');
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List productsJson = data['products'] ?? [];
      return productsJson.map((item) => ProductModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat daftar produk (${response.statusCode})');
    }
  }

  static Future<ProductModel> getProductDetail(int id) async {
    final uri = Uri.parse('$baseUrl/products/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return ProductModel.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail produk (${response.statusCode})');
    }
  }

  static Future<List<String>> getCategories() async {
    final uri = Uri.parse('$baseUrl/products/category-list');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      if (data is List) {
        return data.map((e) {
          if (e is Map && e.containsKey('slug')) {
            return e['slug'].toString();
          }
          return e.toString();
        }).toList();
      }
      return [];
    } else {
      throw Exception('Gagal memuat daftar kategori (${response.statusCode})');
    }
  }
}

