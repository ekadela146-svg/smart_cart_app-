import 'package:flutter/foundation.dart';

import '../helpers/db_helper.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final DBHelper _dbHelper = DBHelper.instance;

  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> loadProducts() async {
    final data = await _dbHelper.getProducts();

    _products = data
        .map((item) => Product.fromMap(item))
        .toList();

    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await _dbHelper.insertProduct(product.toMap());
    await loadProducts();
  }

  Future<void> seedDefaultProducts() async {
    final data = await _dbHelper.getProducts();

    if (data.isNotEmpty) {
      await loadProducts();
      return;
    }

    final defaultProducts = [
      Product(
        name: 'Headphone',
        price: 250000,
        image: 'assets/images/headphone.jpg',
      ),
      Product(
        name: 'Smart Watch',
        price: 350000,
        image: 'assets/images/smartwatch.jpg',
      ),
      Product(
        name: 'Kamera Digital',
        price: 2500000,
        image: 'assets/images/kamera.jpg',
      ),
      Product(
        name: 'Speaker Bluetooth',
        price: 450000,
        image: 'assets/images/speaker.jpg',
      ),
      Product(
        name: 'Keyboard Mechanical',
        price: 650000,
        image: 'assets/images/keyboard.jpg',
      ),
      Product(
        name: 'Mouse Wireless',
        price: 150000,
        image: 'assets/images/mouse.jpg',
      ),
    ];

    for (final product in defaultProducts) {
      await _dbHelper.insertProduct(product.toMap());
    }

    await loadProducts();
  }
}