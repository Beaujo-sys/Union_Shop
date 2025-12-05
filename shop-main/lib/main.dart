import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:union_shop/about_.dart';
import 'package:union_shop/shipping.dart';
import 'package:union_shop/collections.dart';
import 'package:union_shop/product.dart';
import 'package:union_shop/cart.dart';
import 'package:union_shop/cart_repository.dart';
import 'package:union_shop/stylesheet.dart';
import 'package:union_shop/login.dart';
import 'package:union_shop/checkout.dart';
import 'package:union_shop/print_shack.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final cart = CartModel(
    repo: CartRepository(firestore: FirebaseFirestore.instance),
  );
  runApp(CartProvider(cart: cart, child: const UnionShopApp()));
}

class UnionShopApp extends StatelessWidget {
  const UnionShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: Styles.appTheme,
      home: const Shell(),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  final GlobalKey<NavigatorState> _contentNavKey = GlobalKey<NavigatorState>();

  void _push(String route, {Object? args}) {
    final nav = _contentNavKey.currentState;
    if (nav == null) return;
    nav.pushNamed(route, arguments: args);
  }

  void _replaceTo(String route, {Object? args}) {
    final nav = _contentNavKey.currentState;
    if (nav == null) return;
    nav.pushNamedAndRemoveUntil(route, (_) => false, arguments: args);
  }

  void _openSearch() {
    showSearch(context: context, delegate: GlobalSearchDelegate(onNavigate: _push));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const _HeaderBar(),
          Expanded(
            child: Navigator(
              key: _contentNavKey,
              onGenerateInitialRoutes: (NavigatorState nav, String initialRouteName) {
                return [
                  _homeRoute(const RouteSettings(name: '/')),
                ];
              },
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case '/':
                    return _homeRoute(const RouteSettings(name: '/'));
                  case '/about':
                    return MaterialPageRoute(builder: (_) => const AboutPage(), settings: settings);
                  case '/shipping':
                    return MaterialPageRoute(builder: (_) => const ShippingPage(), settings: settings);
                  case '/print-shack':
                    return MaterialPageRoute(builder: (_) => const PrintShackPage(), settings: settings);
                  case '/checkout':
                    return MaterialPageRoute(builder: (_) => const CheckoutPage(), settings: settings);
                  case '/collections':
                    final args = settings.arguments as Map<String, String>?;
                    final initial = args?['open'];
                    return MaterialPageRoute(
                      builder: (_) => CollectionsPage(initialOpenTitle: initial),
                      settings: settings,
                    );
                  case '/product':
                    final args = settings.arguments as Map<String, String>?;
                    return MaterialPageRoute(builder: (_) => ProductPage(item: args), settings: settings);
                  case '/login':
                    return MaterialPageRoute(builder: (_) => const LoginPage(), settings: settings);
                  case '/cart':
                    return MaterialPageRoute(builder: (_) => const CartPage(), settings: settings);
                  default:
                    return _homeRoute(const RouteSettings(name: '/'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

extension on _ShellState {
  MaterialPageRoute _homeRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => HomeBody(
        onNavigate: _push,
        onReplaceTo: _replaceTo,
        onSearch: _openSearch,
      ),
      settings: settings,
    );
  }
}

// Header bar widget
class _HeaderBar extends StatelessWidget {
  const _HeaderBar();

  @override
  Widget build(BuildContext context) {
    return Container(
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

                  void openSearch() {
                    final shell = context.findAncestorStateOfType<_ShellState>()!;
                    shell._openSearch();
                  }
                  void push(String route, {Object? args}) {
                    final shell = context.findAncestorStateOfType<_ShellState>()!;
                    shell._push(route, args: args);
                  }

                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () => push('/', args: null),
                        child: Image.asset(
                          'assets/images/uop_logo.webp',
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
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () => push('/'),
                                  style: TextButton.styleFrom(foregroundColor: const Color(0xFF4d2963)),
                                  child: const Text('Home'),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () => push('/collections', args: {'open': 'SALE'}),
                                  style: TextButton.styleFrom(foregroundColor: const Color(0xFF4d2963)),
                                  child: const Text('Product Sales'),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () => push('/print-shack'),
                                  style: TextButton.styleFrom(foregroundColor: const Color(0xFF4d2963)),
                                  child: const Text('Print Shack'),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () => push('/about'),
                                  style: TextButton.styleFrom(foregroundColor: const Color(0xFF4d2963)),
                                  child: const Text('About Us'),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () => push('/shipping'),
                                  style: TextButton.styleFrom(foregroundColor: const Color(0xFF4d2963)),
                                  child: const Text('Shipping'),
                                ),
                              ],
                            ),
                          ),
                        ),
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
                                            //mobile drop down menu
                                            const SizedBox(height: 12),
                                            item('Home', Icons.home_outlined, () => push('/')),
                                            item('Print Shack', Icons.print_outlined, () => push('/print-shack')),
                                            item('About Us', Icons.info_outline, () => push('/about')),
                                            item('Shipping', Icons.local_shipping_outlined, () => push('/shipping')),
                                            const Divider(height: 0),
                                            item('Search', Icons.search, () => openSearch()),
                                            item('Profile', Icons.person_outline, () => push('/login')),
                                            item('Cart', Icons.shopping_bag_outlined, () => push('/cart')),
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
                                    onPressed: () => openSearch(),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                                    padding: const EdgeInsets.all(8),
                                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                    onPressed: () => push('/login'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.shopping_bag_outlined, size: 18, color: Colors.grey),
                                    padding: const EdgeInsets.all(8),
                                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                    onPressed: () => push('/cart'),
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
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key, required this.onNavigate, required this.onReplaceTo, required this.onSearch});
  final void Function(String route, {Object? args}) onNavigate;
  final void Function(String route, {Object? args}) onReplaceTo;
  final VoidCallback onSearch;

  void navigateToCollections() => onNavigate('/collections');
//Home page
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 400,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/uop_logo2.webp'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7)),
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
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
                      ),
                      const SizedBox(height: 16),
                      const Text('.', style: TextStyle(fontSize: 20, color: Colors.white, height: 1.5), textAlign: TextAlign.center),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: navigateToCollections,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4d2963),
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                        child: const Text('BROWSE COLLECTIONS', style: TextStyle(fontSize: 14, letterSpacing: 1)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
//the 4 products section shown on home page
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  const Text('PRODUCTS SECTION', style: Styles.sectionTitle),
                  const SizedBox(height: 48),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 48,
                    children: const [
                      ProductCard(title: 'Keyring', price: '£3', imageUrl: 'assets/images/uop_keyring.webp'),
                      ProductCard(title: 'Pen', price: '£2.00', imageUrl: 'assets/images/uop_pen.webp'),
                      ProductCard(title: 'T-Shirt', price: '£20.00', imageUrl: 'assets/images/uop_tshirt.webp'),
                      ProductCard(title: 'Cap', price: '£10.00', imageUrl: 'assets/images/uop_cap.webp'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // FOOTER
          Container(
            width: double.infinity,
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: const Footer(),
          ),
        ],
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
            child: Image.asset(
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
              Text(title, style: Styles.productName),
              const SizedBox(height: 4),
              Text(price, style: Styles.priceSmall),
            ],
          ),
        ],
      ),
    );
  }
}
//footer depends on screen size
class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final footerTitleStyle = Styles.sectionTitle.copyWith(fontSize: 16);
          final linkStyle = Styles.body; // rely on stylesheet

          return isWide
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FooterColumn(
                      title: 'Shop',
                      links: const ['All products', 'New', 'Offers'],
                      titleStyle: footerTitleStyle,
                      linkStyle: linkStyle,
                    ),
                    _FooterColumn(
                      title: 'Company',
                      links: const ['About Us', 'Careers', 'Press'],
                      titleStyle: footerTitleStyle,
                      linkStyle: linkStyle,
                    ),
                    _FooterColumn(
                      title: 'Support',
                      links: const ['Contact', 'FAQ', 'Shipping'],
                      titleStyle: footerTitleStyle,
                      linkStyle: linkStyle,
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FooterColumn(
                      title: 'Shop',
                      links: const ['All products', 'New', 'Offers'],
                      titleStyle: footerTitleStyle,
                      linkStyle: linkStyle,
                    ),
                    const SizedBox(height: 12),
                    _FooterColumn(
                      title: 'Company',
                      links: const ['About Us', 'Careers', 'Press'],
                      titleStyle: footerTitleStyle,
                      linkStyle: linkStyle,
                    ),
                    const SizedBox(height: 12),
                    _FooterColumn(
                      title: 'Support',
                      links: const ['Contact', 'FAQ', 'Shipping'],
                      titleStyle: footerTitleStyle,
                      linkStyle: linkStyle,
                    ),
                  ],
                );
        }),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 8),
        Text(
          '© ${DateTime.now().year} Union Shop — All rights reserved',
          style: Styles.footerSmall,
        ),
      ],
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;
  final TextStyle titleStyle;
  final TextStyle linkStyle;

  const _FooterColumn({
    required this.title,
    required this.links,
    required this.titleStyle,
    required this.linkStyle,
  });
//for shipping and about us links in footer
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: titleStyle),
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
            child: Text(link, style: linkStyle),
          ),
      ],
    );
  }
}

class GlobalSearchDelegate extends SearchDelegate<String> {
  GlobalSearchDelegate({required this.onNavigate});
  final void Function(String route, {Object? args}) onNavigate;
//search bar functionality
  final List<SearchEntry> entries = [
    const SearchEntry(label: 'About Us', icon: Icons.info_outline, route: '/about'),
    const SearchEntry(label: 'Shipping', icon: Icons.local_shipping_outlined, route: '/shipping'),
    const SearchEntry(label: 'Profile', icon: Icons.person_outline, route: '/login'),
    const SearchEntry(label: 'Collections', icon: Icons.category_outlined, route: '/collections'),
    const SearchEntry(label: 'Clothing', icon: Icons.checkroom_outlined, route: '/collections'),
    const SearchEntry(label: 'Accessories', icon: Icons.watch_outlined, route: '/collections'),
    const SearchEntry(label: 'Stationery', icon: Icons.edit_outlined, route: '/collections'),
    const SearchEntry(label: 'Sale', icon: Icons.local_offer_outlined, route: '/collections'),
  ];

  List<SearchEntry> _filter(String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) return entries;
    return entries.where((e) => e.label.toLowerCase().contains(query)).toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final items = _filter(query);
    return _buildList(context, items);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final items = _filter(query);
    return _buildList(context, items);
  }
//list of search results
  Widget _buildList(BuildContext context, List<SearchEntry> items) {
    if (items.isEmpty) return const Center(child: Text('No matches'));
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (context, i) {
        final e = items[i];
        return ListTile(
          leading: Icon(e.icon, color: const Color(0xFF4d2963)),
          title: Text(e.label),
          onTap: () {
            close(context, e.label);
            if (e.label.toLowerCase() == 'sale') {
              onNavigate('/collections', args: {'open': 'SALE'});
            } else if (['clothing', 'accessories', 'stationery'].contains(e.label.toLowerCase())) {
              onNavigate('/collections', args: {'open': e.label});
            } else {
              onNavigate(e.route);
            }
          },
        );
      },
    );
  }
}

class SearchEntry {
  final String label;
  final IconData icon;
  final String route;
  const SearchEntry({required this.label, required this.icon, required this.route});
}


