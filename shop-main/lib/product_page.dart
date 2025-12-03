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
    // If the item supplies sizes via a 'sizes' key (comma separated), use that.
    final sizesRaw = item?['sizes'];
    if (sizesRaw != null && sizesRaw.trim().isNotEmpty) {
      return sizesRaw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    }

    // Heuristic: if the title looks like a T‑Shirt, provide standard sizes.
    final titleNorm = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    if (titleNorm.contains('tshirt') || 
        titleNorm.contains('tshirt') ||
        titleNorm.contains('hoodie')){
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
    final description = item?['description'] ?? 'No description available.';
    final image = item?['image'] ?? '';

    final availableSizes = _sizesForItem(title, item);
    // Ensure a default selection if sizes exist and none chosen yet
    if (availableSizes.isNotEmpty && _selectedSize == null) {
      _selectedSize = availableSizes.first;
    }

    void addToBasketDemo() {
      final name = title;
      final sizePart = (availableSizes.isNotEmpty && _selectedSize != null) ? ' (size $_selectedSize)' : '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added $name$sizePart to basket (demo)')),
      );
      // TODO: call real basket-add function here
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF4d2963),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with overlay cart quick-action
            SizedBox(
              height: 240,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  imageWidget(image),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: addToBasketDemo,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.shopping_cart, size: 20, color: Color(0xFF4d2963)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (price.isNotEmpty) Text(price, style: const TextStyle(fontSize: 18, color: Color(0xFF4d2963))),
                const SizedBox(height: 12),

                // Size dropdown (shown only when sizes are available)
                if (availableSizes.isNotEmpty) ...[
                  const Text('Size', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedSize,
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