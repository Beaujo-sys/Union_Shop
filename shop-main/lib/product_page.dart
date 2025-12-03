import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final Map<String, String>? item;
  const ProductPage({super.key, this.item});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? _selectedSize;

  List<String> _sizesForItem(String title, Map<String, String>? item) {
    final sizesRaw = item?['sizes'];
    if (sizesRaw != null && sizesRaw.trim().isNotEmpty) {
      return sizesRaw
          .split(RegExp(r'[;,]')) // support comma or semicolon
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    // Normalize title: remove non-alphanumeric chars so variants like "T‑Shirt" match
    final titleNorm = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

    if (titleNorm.contains('tshirt') || titleNorm.contains('hoodie')) {
      return ['S', 'M', 'L', 'XL'];
    }

    return [];
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
    final price = item?['price'] ?? '';
    final salePrice = item?['salePrice'] ?? '';
    final description = item?['description'] ?? 'No description available.';
    final image = item?['image'] ?? '';

    final availableSizes = _sizesForItem(title, item);
    final currentSelected = _selectedSize ?? (availableSizes.isNotEmpty ? availableSizes.first : null);

    void addToBasketDemo() {
      final chosen = _selectedSize ?? (availableSizes.isNotEmpty ? availableSizes.first : null);
      final sizeText = chosen != null ? ' (size $chosen)' : '';
      final usedPrice = salePrice.isNotEmpty ? salePrice : price;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added $title$sizeText — $usedPrice to basket (demo)')),
      );
      // TODO: replace with real basket add logic
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
                Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                // Price display: show salePrice if present
                if (salePrice.isNotEmpty)
                  Row(
                    children: [
                      if (price.isNotEmpty)
                        Text(
                          price,
                          style: const TextStyle(fontSize: 16, color: Colors.grey, decoration: TextDecoration.lineThrough),
                        ),
                      if (price.isNotEmpty) const SizedBox(width: 8),
                      Text(
                        salePrice,
                        style: const TextStyle(fontSize: 18, color: Colors.redAccent, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                else if (price.isNotEmpty)
                  Text(price, style: const TextStyle(fontSize: 18, color: Color(0xFF4d2963))),

                const SizedBox(height: 12),

                // Size selector (only when sizes available)
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

                const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ]),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addToBasketDemo,
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Add to basket'),
        backgroundColor: const Color(0xFF4d2963),
      ),
    );
  }
}