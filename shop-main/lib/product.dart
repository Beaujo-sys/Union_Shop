import 'package:flutter/material.dart';
import 'package:union_shop/cart.dart';
import 'package:union_shop/stylesheet.dart';

class ProductPage extends StatefulWidget {
  final Map<String, String>? item;
  const ProductPage({super.key, this.item});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? _selectedSize;
  int _quantity = 1;
  late final TextEditingController _qtyCtrl = TextEditingController(text: '1');

  @override
  void dispose() {
    _qtyCtrl.dispose();
    super.dispose();
  }

  List<String> _sizesForItem(String title, Map<String, String>? item) {
    final sizesRaw = item?['sizes'];
    if (sizesRaw != null && sizesRaw.trim().isNotEmpty) {
      return sizesRaw
          .split(RegExp(r'[;,]'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    final titleNorm = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    final categoryNorm = (item?['category'] ?? '').toLowerCase();

    if (categoryNorm == 'clothing' ||
        titleNorm.contains('tshirt') ||
        titleNorm.contains('hoodie') ||
        titleNorm.contains('sweatshirt') ||
        titleNorm.contains('polo') ||
        titleNorm.contains('jacket')) {
      return ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
    }

    return [];
  }

  String _descriptionForItem(Map<String, String>? item) {
    final t = (item?['title'] ?? '').toLowerCase();
    final c = (item?['category'] ?? '').toLowerCase();

    if (c == 'clothing') {
      if (t.contains('hoodie')) return 'Soft cotton-blend hoodie with UoP theme.';
      if (t.contains('tshirt') || t.contains('t‑shirt')) return 'Classic T‑shirt featuring the UoP colours.';
      if (t.contains('sweatshirt')) return 'Comfort-fit sweatshirt for everyday wear.';
      if (t.contains('jacket')) return 'Lightweight jacket suitable for campus commutes.';
      if (t.contains('polo')) return 'Smart-casual polo shirt.';
      if (t.contains('beanie')) return 'Warm knit beanie in UoP colors.';
      if (t.contains('scarf')) return 'Winter scarf to keep you warm on cold days.';
      return 'UoP apparel made for comfort and style.';
    }

    if (c == 'accessories') {
      if (t.contains('backpack')) return 'Durable backpack with spacious compartments.';
      if (t.contains('cap')) return 'Adjustable cap with UoP theme.';
      if (t.contains('lanyard')) return 'Secure lanyard for ID cards and keys.';
      if (t.contains('keyring')) return 'Metal keyring.';
      if (t.contains('water bottle')) return 'Reusable bottle to stay hydrated on campus.';
      if (t.contains('tote')) return 'Canvas tote for books and daily essentials.';
      if (t.contains('badge')) return 'Badge';
      return 'Practical UoP accessories for daily use.';
    }

    if (c == 'stationery') {
      if (t.contains('notebook')) return 'A5 notebook with lined pages for lectures.';
      if (t.contains('pen')) return 'Smooth-writing ballpoint pen.';
      if (t.contains('pencil')) return 'HB pencil for notes and sketches.';
      if (t.contains('highlighter')) return 'Bright highlighter for study notes.';
      if (t.contains('folder')) return 'Document folder to keep papers organized.';
      if (t.contains('sticky')) return 'Sticky notes for quick reminders.';
      if (t.contains('ruler')) return '30cm ruler with clear markings.';
      if (t.contains('planner')) return 'Weekly planner to manage your schedule.';
      return 'Study-ready stationery for every course.';
    }

    return 'Official UoP merchandise.';
  }

  Widget imageWidget(String image) {
    if (image.isEmpty) {
      return Container(height: 240, color: Colors.grey[200], child: const Center(child: Icon(Icons.broken_image)));
    }
    if (image.startsWith('assets/')) {
      return Image.asset(image, height: 240, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
        return Container(height: 240, color: Colors.grey[200], child: const Center(child: Icon(Icons.broken_image)));
      });
    }
    return Image.network(image, height: 240, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
      return Container(height: 240, color: Colors.grey[200], child: const Center(child: Icon(Icons.broken_image)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final title = item?['title'] ?? 'Product';
    final priceStr = item?['price'] ?? '';
    final salePriceStr = item?['salePrice'] ?? '';
    final image = item?['image'] ?? '';
    final description = (item?['description']?.trim().isNotEmpty == true)
        ? item!['description']!
        : _descriptionForItem(item);

    double _parse(String s) {
      final cleaned = s.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }
    final unitPrice = salePriceStr.isNotEmpty ? _parse(salePriceStr) : _parse(priceStr);

    final availableSizes = _sizesForItem(title, item);
    final currentSelected = _selectedSize ?? (availableSizes.isNotEmpty ? availableSizes.first : null);

    void addToCart() {
      final cart = CartProvider.of(context);
      cart.addItem(CartItem(
        title: title,
        image: image,
        unitPrice: unitPrice,
        quantity: _quantity,
        size: currentSelected,
      ));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added $_quantity × $title')));
    }

    void _setQuantity(int q) {
      final newQ = q < 1 ? 1 : q;
      setState(() {
        _quantity = newQ;
        _qtyCtrl.text = '$newQ';
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: const Color(0xFF4d2963)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageWidget(image),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: Styles.title),
                const SizedBox(height: 8),

                if (salePriceStr.isNotEmpty)
                  Row(
                    children: [
                      if (priceStr.isNotEmpty)
                        Text(
                          priceStr,
                          style: Styles.strikePrice,
                        ),
                      if (priceStr.isNotEmpty) const SizedBox(width: 8),
                      Text(
                        salePriceStr,
                        style: Styles.salePrice,
                      ),
                    ],
                  )
                else if (priceStr.isNotEmpty)
                  Text(priceStr, style: Styles.price),

                const SizedBox(height: 12),

                if (availableSizes.isNotEmpty) ...[
                  const Text('Size', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: currentSelected,
                    items: availableSizes.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (val) => setState(() => _selectedSize = val),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Quantity selector
                const Text('Quantity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Decrease',
                      onPressed: () => _setQuantity(_quantity - 1),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    SizedBox(
                      width: 64,
                      child: TextFormField(
                        controller: _qtyCtrl,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (v) {
                          final n = int.tryParse(v);
                          if (n != null && n > 0) {
                            _quantity = n; // do not setState to avoid cursor jump
                          }
                        },
                        onEditingComplete: () {
                          final n = int.tryParse(_qtyCtrl.text) ?? _quantity;
                          _setQuantity(n);
                          FocusScope.of(context).unfocus();
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Increase',
                      onPressed: () => _setQuantity(_quantity + 1),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                const Text('Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(description, style: Styles.body),
              ]),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: addToCart,
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to cart'),
            backgroundColor: const Color(0xFF4d2963),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/cart'),
            tooltip: 'View cart',
            child: const Icon(Icons.shopping_bag_outlined),
            backgroundColor: const Color(0xFF4d2963),
          ),
        ],
      ),
    );
  }
}