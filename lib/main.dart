import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/cart_page.dart';
import 'pages/product_page.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider()..loadCart(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider()..seedDefaultProducts(),
        ),
      ],
      child: const SmartCartApp(),
    ),
  );
}

class SmartCartApp extends StatelessWidget {
  const SmartCartApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart-Cart & E-Catalog',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3F3A82),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          ProductPage(
            onCartTap: () {
              setState(() {
                currentIndex = 1;
              });
            },
          ),
          CartPage(
            onBack: () {
              setState(() {
                currentIndex = 0;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedIndex: currentIndex,
        indicatorColor: Colors.transparent,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.grid_view_outlined,
              color: currentIndex == 0
                  ? Colors.black
                  : Colors.grey,
            ),
            selectedIcon: const Icon(
              Icons.grid_view,
              color: Colors.black,
            ),
            label: 'Katalog',
          ),
          NavigationDestination(
            icon: Consumer<CartProvider>(
              builder: (
                context,
                cart,
                child,
              ) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: currentIndex == 1
                          ? Colors.black
                          : Colors.grey,
                    ),
                    if (cart.totalItems > 0)
                      Positioned(
                        right: -7,
                        top: -7,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFF20A83B),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${cart.totalItems}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            selectedIcon: Consumer<CartProvider>(
              builder: (
                context,
                cart,
                child,
              ) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                    ),
                    if (cart.totalItems > 0)
                      Positioned(
                        right: -7,
                        top: -7,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFF20A83B),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${cart.totalItems}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: 'Keranjang',
          ),
        ],
      ),
    );
  }
}