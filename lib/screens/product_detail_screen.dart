import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchProductById(widget.productId);
  }

  void _retry() {
    setState(() {
      _future = ApiService.fetchProductById(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: FutureBuilder<Product>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(
              message: 'Đang tải chi tiết...',
            );
          }

          if (snapshot.hasError) {
            return AppErrorWidget(
              message: 'Lỗi tải chi tiết.\n${snapshot.error}',
              onRetry: _retry,
            );
          }

          final product = snapshot.data;

          if (product == null) {
            return const Center(child: Text('Không có dữ liệu.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    product.image,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 80,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                Text(product.description),
              ],
            ),
          );
        },
      ),
    );
  }
}