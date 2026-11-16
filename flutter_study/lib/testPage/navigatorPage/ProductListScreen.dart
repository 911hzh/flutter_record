import 'package:flutter/material.dart';
import 'package:flutter_study/testPage/navigatorPage/DemoHeader.dart';
import 'package:flutter_study/testPage/navigatorPage/Product.dart';

class ProductListScreen extends StatelessWidget {
  final List<Product> products;
  final ValueChanged<String> onProductSelected;

  const ProductListScreen({required this.products, required this.onProductSelected});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DemoHeader(title: '声明式页面栈', subtitle: '当前 pages: [列表页]'),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 0,
                  color: Colors.deepPurple.shade50,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(product.name),
                    subtitle: Text(product.description),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => onProductSelected(product.id),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemCount: products.length,
            ),
          ),
        ],
      ),
    );
  }
}
