import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final Map<String, String>? item;
  const ProductPage({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    final title = item?['title'] ?? 'Product';
    final price = item?['price'] ?? '';
    final description = item?['description'] ?? 'No description available.';
    final image = item?['image'] ?? '';

    Widget imageWidget() {
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
                  // reuse the existing imageWidget
                  imageWidget(),
                  // small shopping-cart overlay button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        final name = title;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added $name to basket (demo)')),
                        );
                        // TODO: call real basket-add function here
                      },
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
                const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ]),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final name = title;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Added $name to basket (demo)')),
          );
          // TODO: call your real basket-add function here
        },
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Add to basket'),
        backgroundColor: const Color(0xFF4d2963),
      ),
    );
  }
}