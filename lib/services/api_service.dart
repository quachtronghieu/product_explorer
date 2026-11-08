import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com/products';

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode != 200) {
      throw Exception(
        'Không tải được danh sách: HTTP ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as List<dynamic>;

    return data
        .map(
          (item) => Product.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  static Future<Product> fetchProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception(
        'Không tải được sản phẩm: HTTP ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return Product.fromJson(data);
  }
}