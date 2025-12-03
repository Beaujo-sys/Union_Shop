import 'package:flutter/material.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  void openProduct(BuildContext context) {
    Navigator.pushNamed(context, '/product');
  }

  @override
  Widget build(BuildContext context) {
    final collections = <Map<String, dynamic>>[
      {
        'title': 'Clothing',
        'items': [
          {'title': 'T‑Shirt', 'price': '£20', 'image': 'https://via.placeholder.com/300'},
          {'title': 'Hoodie', 'price': '£35', 'image': 'https://via.placeholder.com/300'},
        ],
      },
      {
        'title': 'Accessories',
        'items': [
          {'title': 'Cap', 'price': '£10', 'image': 'https://via.placeholder.com/300'},
          {'title': 'Bag', 'price': '£18', 'image': 'https://via.placeholder.com/300'},
        ],
      },
      {
        'title': 'Stationery',
        'items': [
          {'title': 'Notebook', 'price': '£5', 'image': 'https://via.placeholder.com/300'},
          {'title': 'Pen', 'price': '£2', 'image': 'https://via.placeholder.com/300'},
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collections'),
        backgroundColor: const Color(0xFF4d2963),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final col = collections[index];
          final items = col['items'] as List<Map<String, String>>;
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  col['title'] as String,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final item = items[i];
                      return GestureDetector(
                        onTap: () => openProduct(context),
                        child: SizedBox(
                          width: 160,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item['image']!,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, e, st) => Container(
                                      color: Colors.grey[300],
                                      child: const Center(child: Icon(Icons.image_not_supported)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(item['title']!, style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(item['price']!, style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}