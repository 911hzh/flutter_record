import 'package:flutter/material.dart';
import 'package:flutter_study/module/usecase/pages/navigation/DemoHeader.dart';
import 'package:flutter_study/module/usecase/pages/navigation/Product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final VoidCallback onBack;

  const ProductDetailScreen({required this.product, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DemoHeader(title: product.name, subtitle: '当前 pages: [列表页, 详情页]'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.description, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 20),
                  const Text(
                    'Navigator 2.0 的重点是：页面栈由状态决定。这里的详情页来自 selectedProductId，'
                    '返回时 selectedProductId 被清空，pages 列表重新变回只有列表页。',
                  ),
                  const Spacer(),
                  FilledButton.icon(onPressed: onBack, icon: const Icon(Icons.arrow_back), label: const Text('返回列表')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
