import 'package:flutter/material.dart';
import 'package:flutter_study/testPage/navigatorPage/NavigatorDemoPage.dart';
import 'package:flutter_study/testPage/navigatorPage/Product.dart';
import 'package:flutter_study/testPage/navigatorPage/ProductDetailScreen.dart';
import 'package:flutter_study/testPage/navigatorPage/ProductListScreen.dart';

class NavigatorDemoRouterDelegate extends RouterDelegate<NavigatorDemoRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavigatorDemoRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final List<Product> _products = const [
    Product(id: 'router', name: 'RouterDelegate', description: '保存导航状态，并根据状态构建 Navigator.pages。'),
    Product(id: 'parser', name: 'RouteInformationParser', description: '把浏览器地址或深链解析成应用内部的路由配置。'),
    Product(id: 'pages', name: 'Navigator.pages', description: '用 Page 列表声明当前页面栈，状态改变后由框架完成增删页面。'),
  ];

  String? _selectedProductId;

  Product? get _selectedProduct {
    for (final product in _products) {
      if (product.id == _selectedProductId) {
        return product;
      }
    }
    return null;
  }

  @override
  NavigatorDemoRoutePath get currentConfiguration {
    final selectedProductId = _selectedProductId;
    if (selectedProductId == null) {
      return const NavigatorDemoRoutePath.home();
    }
    return NavigatorDemoRoutePath.detail(selectedProductId);
  }

  @override
  Future<void> setNewRoutePath(NavigatorDemoRoutePath configuration) async {
    _selectedProductId = configuration.productId;
  }

  void openProduct(String productId) {
    _selectedProductId = productId;
    notifyListeners();
  }

  void closeProduct() {
    _selectedProductId = null;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final selectedProduct = _selectedProduct;

    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey('navigator-demo-list'),
          child: ProductListScreen(products: _products, onProductSelected: openProduct),
        ),
        if (selectedProduct != null)
          MaterialPage(
            key: ValueKey('navigator-demo-detail-${selectedProduct.id}'),
            child: ProductDetailScreen(product: selectedProduct, onBack: closeProduct),
          ),
      ],
      onDidRemovePage: (page) {
        if (_selectedProductId != null) {
          _selectedProductId = null;
          notifyListeners();
        }
      },
    );
  }
}
