import 'package:flutter/foundation.dart';

import '../helpers/db_helper.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final DBHelper _dbHelper = DBHelper.instance;

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalItems {
    return _items.fold(
      0,
      (total, item) => total + item.quantity,
    );
  }

  double get totalPrice {
    return _items.fold(
      0,
      (total, item) =>
          total + (item.product.price * item.quantity),
    );
  }

  Future<void> loadCart() async {
    final data = await _dbHelper.getCartItems();

    _items.clear();

    final products = await _dbHelper.getProducts();

    for (final cartData in data) {
      final productId = cartData['product_id'] as int;

      final productData =
          products.cast<Map<String, dynamic>>().firstWhere(
        (product) => product['id'] == productId,
        orElse: () => <String, dynamic>{},
      );

      if (productData.isNotEmpty) {
        final product = Product.fromMap(productData);

        _items.add(
          CartItem.fromMap(
            cartData,
            product,
          ),
        );
      }
    }

    notifyListeners();
  }

  Future<void> addToCart(Product product) async {
    final index = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      _items[index].quantity++;

      if (_items[index].id != null) {
        await _dbHelper.updateCartQuantity(
          _items[index].id!,
          _items[index].quantity,
        );
      }
    } else {
      final cartItem = CartItem(
        product: product,
        quantity: 1,
      );

      final cartId = await _dbHelper.insertCart(
        cartItem.toMap(),
      );

      _items.add(
        CartItem(
          id: cartId,
          product: product,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  Future<void> increment(Product product) async {
    final index = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      _items[index].quantity++;

      if (_items[index].id != null) {
        await _dbHelper.updateCartQuantity(
          _items[index].id!,
          _items[index].quantity,
        );
      }

      notifyListeners();
    }
  }

  Future<void> decrement(Product product) async {
    final index = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;

        if (_items[index].id != null) {
          await _dbHelper.updateCartQuantity(
            _items[index].id!,
            _items[index].quantity,
          );
        }
      } else {
        if (_items[index].id != null) {
          await _dbHelper.deleteCartItem(
            _items[index].id!,
          );
        }

        _items.removeAt(index);
      }

      notifyListeners();
    }
  }

  Future<void> removeFromCart(Product product) async {
    final index = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (index >= 0) {
      if (_items[index].id != null) {
        await _dbHelper.deleteCartItem(
          _items[index].id!,
        );
      }

      _items.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    for (final item in _items) {
      if (item.id != null) {
        await _dbHelper.deleteCartItem(item.id!);
      }
    }

    _items.clear();
    notifyListeners();
  }
}