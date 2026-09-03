import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  final VoidCallback onBack;

  const CartPage({
    super.key,
    required this.onBack,
  });

  String formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),

      appBar: AppBar(
        backgroundColor: const Color(0xFF3F3A82),
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 78,

        leading: IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
        ),

        centerTitle: true,

        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return IconButton(
                tooltip: 'Hapus semua',
                onPressed: cart.items.isEmpty
                    ? null
                    : () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: const Text(
                                'Hapus Keranjang?',
                              ),
                              content: const Text(
                                'Semua produk akan dihapus dari keranjang.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                      dialogContext,
                                    );
                                  },
                                  child: const Text(
                                    'Batal',
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    cart.clearCart();

                                    Navigator.pop(
                                      dialogContext,
                                    );
                                  },
                                  child: const Text(
                                    'Hapus',
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                icon: const Icon(
                  Icons.delete_outline,
                ),
              );
            },
          ),
        ],
      ),

      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Keranjang masih kosong',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Tambahkan produk terlebih dahulu',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // DAFTAR PRODUK
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(
                    screenWidth < 360 ? 8 : 12,
                  ),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    final product = item.product;

                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      padding: EdgeInsets.all(
                        screenWidth < 360 ? 7 : 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          // GAMBAR PRODUK
                          SizedBox(
                            width:
                                screenWidth < 360 ? 62 : 78,
                            height:
                                screenWidth < 360 ? 62 : 78,
                            child: Image.asset(
                              product.image,
                              fit: BoxFit.contain,
                              errorBuilder: (
                                context,
                                error,
                                stackTrace,
                              ) {
                                return const Icon(
                                  Icons
                                      .image_not_supported,
                                  size: 35,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),

                          SizedBox(
                            width:
                                screenWidth < 360 ? 7 : 12,
                          ),

                          // NAMA DAN HARGA
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize:
                                        screenWidth < 360
                                            ? 11
                                            : 13,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  formatPrice(
                                    product.price,
                                  ),
                                  style: TextStyle(
                                    fontSize:
                                        screenWidth < 360
                                            ? 10
                                            : 12,
                                    color:
                                        const Color(
                                      0xFF20A83B,
                                    ),
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // KONTROL JUMLAH
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  cart.removeFromCart(
                                    product,
                                  );
                                },
                                child: const Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                ),
                              ),

                              const SizedBox(height: 18),

                              Row(
                                mainAxisSize:
                                    MainAxisSize.min,
                                children: [
                                  QuantityButton(
                                    icon: Icons.remove,
                                    onTap: () {
                                      cart.decrement(
                                        product,
                                      );
                                    },
                                  ),

                                  SizedBox(
                                    width:
                                        screenWidth < 360
                                            ? 23
                                            : 30,
                                    child: Center(
                                      child: Text(
                                        '${item.quantity}',
                                        style:
                                            const TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  QuantityButton(
                                    icon: Icons.add,
                                    onTap: () {
                                      cart.increment(
                                        product,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // TOTAL
              Container(
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(
                  screenWidth < 360 ? 8 : 12,
                  0,
                  screenWidth < 360 ? 8 : 12,
                  10,
                ),
                padding: EdgeInsets.all(
                  screenWidth < 360 ? 10 : 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Item',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${cart.totalItems}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Harga',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          formatPrice(
                            cart.totalPrice,
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            color:
                                Color(0xFF20A83B),
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                title: const Text(
                                  'Checkout',
                                ),
                                content: Text(
                                  'Total pembayaran: '
                                  '${formatPrice(cart.totalPrice)}',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        dialogContext,
                                      );
                                    },
                                    child: const Text(
                                      'OK',
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF20A83B),
                          foregroundColor:
                              Colors.white,
                          elevation: 0,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              22,
                            ),
                          ),
                        ),
                        child: Text(
                          'Checkout (${cart.totalItems})',
                          style:
                              const TextStyle(
                            fontSize: 13,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const QuantityButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
          ),
          borderRadius:
              BorderRadius.circular(7),
        ),
        child: Icon(
          icon,
          size: 14,
          color: Colors.blue,
        ),
      ),
    );
  }
}