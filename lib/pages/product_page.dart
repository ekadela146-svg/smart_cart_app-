import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';

class ProductPage extends StatefulWidget {
  final VoidCallback onCartTap;

  const ProductPage({
    super.key,
    required this.onCartTap,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController searchController =
      TextEditingController();

  final List<Product> products = [
    Product(
      id: 1,
      name: 'Headphone',
      price: 250000,
      image: 'assets/images/headphone.jpg',
    ),
    Product(
      id: 2,
      name: 'Smart Watch',
      price: 350000,
      image: 'assets/images/smartwatch.jpg',
    ),
    Product(
      id: 3,
      name: 'Kamera Digital',
      price: 2500000,
      image: 'assets/images/kamera.jpg',
    ),
    Product(
      id: 4,
      name: 'Speaker Bluetooth',
      price: 450000,
      image: 'assets/images/speaker.jpg',
    ),
    Product(
      id: 5,
      name: 'Keyboard Mechanical',
      price: 650000,
      image: 'assets/images/keyboard.jpg',
    ),
    Product(
      id: 6,
      name: 'Mouse Wireless',
      price: 150000,
      image: 'assets/images/mouse.jpg',
    ),
  ];

  String searchText = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<Product> get filteredProducts {
    if (searchText.trim().isEmpty) {
      return products;
    }

    return products.where((product) {
      return product.name
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF3F3A82),
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 78,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Smart-Cart',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '& E-Catalog',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF42D66A),
              ),
            ),
          ],
        ),

        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: widget.onCartTap,
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(9),
                        ),
                        child: const Icon(
                          Icons.shopping_cart,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),

                      if (cart.totalItems > 0)
                        Positioned(
                          right: -6,
                          top: -7,
                          child: Container(
                            constraints:
                                const BoxConstraints(
                              minWidth: 19,
                              minHeight: 19,
                            ),
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            decoration:
                                const BoxDecoration(
                              color: Color(0xFF20A83B),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${cart.totalItems}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // SEARCH BAR
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              12,
              8,
              12,
              14,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF3F3A82),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Cari Produk...',
                  hintStyle: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 19,
                    color: Colors.grey,
                  ),
                  suffixIcon: searchText.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();

                            setState(() {
                              searchText = '';
                            });
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 18,
                            color: Colors.grey,
                          ),
                        )
                      : null,
                  contentPadding:
                      const EdgeInsets.symmetric(
                    vertical: 9,
                  ),
                ),
              ),
            ),
          ),

          // HASIL PRODUK
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 55,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Produk tidak ditemukan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Coba cari dengan kata lain',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.fromLTRB(
                      screenWidth < 360 ? 8 : 12,
                      15,
                      screenWidth < 360 ? 8 : 12,
                      15,
                    ),
                    itemCount: filteredProducts.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing:
                          screenWidth < 360 ? 10 : 14,
                      mainAxisSpacing: 14,
                      childAspectRatio:
                          screenWidth < 360 ? 0.75 : 0.78,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: filteredProducts[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}