import 'package:flutter/material.dart';
import 'package:union_shop/about_page.dart';
import 'package:union_shop/shipping_page.dart';
import 'package:union_shop/collections.dart';
import 'package:union_shop/product_page.dart'; // <-- added
import 'package:union_shop/profile.dart'; // <-- added

void main() {
  runApp(const UnionShopApp());
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/about': (context) => const AboutPage(),
        '/shipping': (context) => const ShippingPage(),
        '/profile': (context) => const ProfilePage(), // <- new profile route
        '/collections': (context) => const CollectionsPage(),

        // '/product' now uses a generic ProductPage (NOT TShirtPage)
        '/product': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
          return ProductPage(item: args);
        },
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToProduct(BuildContext context) {
    Navigator.pushNamed(context, '/product');
  }

  void navigateToProfile(BuildContext context) {
    Navigator.pushNamed(context, '/profile');
  }

  void navigateToAbout(BuildContext context) {
    Navigator.pushNamed(context, '/about');
  }

  void navigateToCollections(BuildContext context) {
    Navigator.pushNamed(context, '/collections');
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header (includes search, account, basket, menu icons, about)
            Container(
              height: 100,
              color: Colors.white,
              child: Column(
                children: [
                  // Top banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    color: const Color(0xFF4d2963),
                    child: const Text(
                      'CHRISTMAS IS COMING - FREE DELIVERY ON ORDERS OVER £30',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  // Main header
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              navigateToHome(context);
                            },
                            child: Image.network(
                              'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                              height: 18,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  width: 18,
                                  height: 18,
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported,
                                        color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),
                          const Spacer(),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  onPressed: placeholderCallbackForButtons,
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.person_outline,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  onPressed: () => navigateToProfile(context),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                  onPressed: placeholderCallbackForButtons,
                                ),
                                // Menu with About entry (single dropdown)
                                PopupMenuButton<String>(
                                   icon: const Icon(
                                     Icons.menu,
                                     size: 18,
                                     color: Colors.grey,
                                   ),
                                   onSelected: (value) {
                                     if (value == 'about') {
                                       navigateToAbout(context);
                                     } else {
                                       // handle other menu items if added later
                                     }
                                   },
                                   itemBuilder: (context) => const [
                                     PopupMenuItem(
                                       value: 'about',
                                       child: Text('About Us'),
                                     ),
                                   ],
                                 ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Hero Section
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Stack(
                children: [
                  // Background image
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282'), // <- replace with your hero filename
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
                  // Content overlay
                  Positioned(
                    left: 24,
                    right: 24,
                    top: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'WELCOME TO THE UNION SHOP',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          ".",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () => navigateToCollections(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4d2963),
                            foregroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text(
                            'BROWSE COLLECTIONS',
                            style: TextStyle(fontSize: 14, letterSpacing: 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Products Section
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    const Text(
                      'PRODUCTS SECTION',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 48),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 2 : 1,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 48,
                      children: const [
                        ProductCard(
                          title: 'Hoodie ',
                          price: '£15',
                          imageUrl: 'assets/images/uop_hoodie.webp',
                        ),
                        ProductCard(
                          title: 'Pen',
                          price: '£2.00',
                          imageUrl: 'assets/images/uop_pen.webp',
                        ),
                        ProductCard(
                          title: 'T-Shirt',
                          price: '£20.00',
                          imageUrl: 'assets/images/uop_tshirt.webp',
                        ),
                        ProductCard(
                          title: 'Cap',
                          price: '£10.00',
                          imageUrl: 'assets/images/uop_cap.webp',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              width: double.infinity,
              color: Colors.grey[100],
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: const Footer(),
            ),
          ],
        ),
      ),
    );
  }
}
 
class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;
 
  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
  });
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // pass the item map so ProductPage can read title/price/image (and salePrice if present)
        Navigator.pushNamed(
          context,
          '/product',
          arguments: {'title': title, 'price': price, 'image': imageUrl},
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
 
// Add footer widget
class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return isWide
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _FooterColumn(
                      title: 'Shop',
                      links: ['All products', 'New', 'Offers'],
                    ),
                    _FooterColumn(
                      title: 'Company',
                      links: ['About Us', 'Careers', 'Press'],
                    ),
                    _FooterColumn(
                      title: 'Support',
                      links: ['Contact', 'FAQ', 'Shipping'],
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _FooterColumn(
                      title: 'Shop',
                      links: ['All products', 'New', 'Offers'],
                    ),
                    SizedBox(height: 12),
                    _FooterColumn(
                      title: 'Company',
                      links: ['About Us', 'Careers', 'Press'],
                    ),
                    SizedBox(height: 12),
                    _FooterColumn(
                      title: 'Support',
                      links: ['Contact', 'FAQ', 'Shipping'],
                    ),
                  ],
                );
        }),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
        const Text(
          '© ${2025} Union Shop — All rights reserved',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;
  const _FooterColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        for (final link in links)
          TextButton(
            onPressed: () {
              if (link == 'Shipping') {
                Navigator.pushNamed(context, '/shipping');
              } else if (link == 'About Us') {
                Navigator.pushNamed(context, '/about');
              } else {
                // non-functional placeholder for other links
              }
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 28),
              alignment: Alignment.centerLeft,
            ),
            child: Text(link, style: const TextStyle(color: Colors.grey)),
          ),
      ],
    );
  }
}

