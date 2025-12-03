import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  static const Map<String, String> _imageMap = {
    'hoodie': 'assets/images/uop_hoodie.webp',
    'hood': 'assets/images/uop_hoodie.webp',
    'tshirt': 'assets/images/uop_tshirt.webp',
    't-shirt': 'assets/images/uop_tshirt.webp',
    't shirt': 'assets/images/uop_tshirt.webp',
    'cap': 'assets/images/uop_cap.webp',
    'backpack': 'assets/images/uop_backpack.webp',
    'bag': 'assets/images/uop_backpack.webp',
    'notebook': 'assets/images/uop_notebook.webp',
    'pen': 'assets/images/uop_pen.webp',
  };

  String _normalize(String s) {
    return s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\-\s]'), ' ').trim();
  }

  String _resolveImage(String? provided, String title) {
    if (provided != null && provided.isNotEmpty) {
      final p = provided.trim();
      if (p.startsWith('assets/') || p.startsWith('http')) return p;
      // bare filename -> assume assets/images/
      if (!p.contains('/')) return 'assets/images/$p';
    }
    final norm = _normalize(title);
    for (final entry in _imageMap.entries) {
      if (norm.contains(entry.key)) return entry.value;
    }
    return ''; // empty => placeholder shown
  }

  Future<int?> _showBuyDialog(BuildContext context, String title, String price, int initial) async {
    int qty = initial;
    return showDialog<int>(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: Text('Buy $title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Price: $price'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: qty > 1 ? () => setState(() => qty--) : null,
                  ),
                  Text('$qty', style: const TextStyle(fontSize: 18)),
                  IconButton(icon: const Icon(Icons.add), onPressed: () => setState(() => qty++)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(null), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
              onPressed: () => Navigator.of(context).pop(qty),
              child: const Text('Confirm'),
            ),
          ],
        );
      }),
    );
  }

  Widget _imageWidget(String path) {
    if (path.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Center(child: Icon(Icons.image_not_supported, size: 56, color: Colors.grey)),
      );
    }
    if (path.startsWith('assets/')) {
      return Image.asset(path, fit: BoxFit.cover, width: double.infinity, errorBuilder: (_, __, ___) {
        return Container(color: Colors.grey[200], child: const Center(child: Icon(Icons.broken_image)));
      });
    }
    return Image.network(path, fit: BoxFit.cover, width: double.infinity, errorBuilder: (_, __, ___) {
      return Container(color: Colors.grey[200], child: const Center(child: Icon(Icons.broken_image)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final Map<String, dynamic> data = (args is Map) ? Map<String, dynamic>.from(args) : <String, dynamic>{};

    final title = (data['title'] ?? 'Product').toString();
    final price = (data['price'] ?? '£0.00').toString();
    final description = (data['description'] ??
            'No description available.').toString();
    final providedImage = (data['image'] ?? '').toString();
    final imagePath = _resolveImage(providedImage, title);

    int qty = 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF4d2963),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).maybePop()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product image
            Container(height: 320, width: double.infinity, color: Colors.grey[200], child: _imageWidget(imagePath)),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(price, style: const TextStyle(fontSize: 20, color: Color(0xFF4d2963), fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                const Text('Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(fontSize: 15, color: Colors.grey)),

                const SizedBox(height: 20),

                Row(children: [
                  Row(children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: qty > 1 ? () => qty-- : null,
                    ),
                    Text('$qty', style: const TextStyle(fontSize: 18)),
                    IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => qty++),
                  ]),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await _showBuyDialog(context, title, price, qty);
                      if (result != null) {
                        qty = result;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Purchased $qty × $title (demo)')));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4d2963)),
                    child: const Text('Buy now'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added $qty × $title to cart (demo)'))),
                    child: const Text('Add to cart'),
                  ),
                ]),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}