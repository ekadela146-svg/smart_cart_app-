import 'product.dart';

class CartItem {
  final int? id;
  final Product product;
  int quantity;

  CartItem({
    this.id,
    required this.product,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': product.id,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(
    Map<String, dynamic> map,
    Product product,
  ) {
    return CartItem(
      id: map['id'] as int?,
      product: product,
      quantity: map['quantity'] as int,
    );
  }
}