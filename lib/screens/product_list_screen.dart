import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchProducts();
  }

  void _retry() {
    setState(() {
      _future = ApiService.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: FutureBuilder<List<Product>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(
              message: 'Đang tải sản phẩm...',
            );
          }

          if (snapshot.hasError) {
            return AppErrorWidget(
              message: 'Lỗi tải danh sách.\n${snapshot.error}',
              onRetry: _retry,
            );
          }

          final products = snapshot.data;

          if (products == null || products.isEmpty) {
            return const Center(
              child: Text('Không có sản phẩm.'),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ListTile(
                leading: Image.network(
                  product.image,
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported);
                  },
                ),
                title: Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) {
                        return ProductDetailScreen(
                          productId: product.id,
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}