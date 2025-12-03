import 'package:flutter/material.dart';
import 'package:union_shop/about_page.dart';
import 'package:union_shop/shipping_page.dart';
import 'package:union_shop/collections.dart';
import 'package:union_shop/product_page.dart';
import 'package:union_shop/profile.dart';

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
        '/profile': (context) => const ProfilePage(),
        '/collections': (context) => const CollectionsPage(),

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
            Container(
              height: 100,
              color: Colors.white,
              child: Column(
                children: [
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
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isMobile = constraints.maxWidth < 500;

                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () => navigateToHome(context),
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
                                        child: Icon(Icons.image_not_supported, color: Colors.grey),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),

                              if (!isMobile)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      onPressed: () => navigateToHome(context),
                                      style: TextButton.styleFrom(foregroundColor: const Color(0xFF4d2963)),
                                      child: const Text('Home'),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Navigating to Product Sales')),
                                        );
                                      },
                                      style: TextButton.styleFrom(foregroundColor: const Color(0xFF4d2963)),
                                      child: const Text('Product Sales'),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton(
                                      onPressed: () => navigateToAbout(context),
                                      style: TextButton.styleFrom(foregroundColor: const Color(0xFF4d2963)),
                                      child: const Text('About Us'),
                                    ),
                                  ],
                                ),

                              const Spacer(),

                              ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 600),
                                child: isMobile
                                    ? IconButton(
                                        icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                            ),
                                            builder: (ctx) {
                                              Widget item(String label, IconData icon, VoidCallback onTap) {
                                                return ListTile(
                                                  leading: Icon(icon, color: const Color(0xFF4d2963)),
                                                  title: Text(label),
                                                  onTap: () {
                                                    Navigator.pop(ctx);
                                                    onTap();
                                                  },
                                                );
                                              }

                                              return SafeArea(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    Container(
                                                      height: 4,
                                                      width: 48,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[300],
                                                        borderRadius: BorderRadius.circular(2),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    item('Home', Icons.home_outlined, () => navigateToHome(context)),
                                                    item('Product Sales', Icons.local_offer_outlined, () {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(content: Text('Navigating to Product Sales')),
                                                      );
                                                    }),
                                                    item('About Us', Icons.info_outline, () => navigateToAbout(context)),
                                                    const Divider(height: 0),
                                                    item('Search', Icons.search, placeholderCallbackForButtons),
                                                    item('Profile', Icons.person_outline, () => navigateToProfile(context)),
                                                    item('Cart', Icons.shopping_bag_outlined, placeholderCallbackForButtons),
                                                    const SizedBox(height: 8),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.search, size: 18, color: Colors.grey),
                                            padding: const EdgeInsets.all(8),
                                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                            onPressed: placeholderCallbackForButtons,
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                                            padding: const EdgeInsets.all(8),
                                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                            onPressed: () => navigateToProfile(context),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.shopping_bag_outlined, size: 18, color: Colors.grey),
                                            padding: const EdgeInsets.all(8),
                                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                            onPressed: placeholderCallbackForButtons,
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.info_outline, size: 18, color: Colors.grey),
                                            padding: const EdgeInsets.all(8),
                                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                            onPressed: () => navigateToAbout(context),
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 400,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282'),
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

