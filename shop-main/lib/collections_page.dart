import 'package:flutter/material.dart';
import 'package:union_shop/collection_items_page.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  void openCollection(BuildContext context, String title, List<Map<String, String>> items) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CollectionItemsPage(title: title, items: items),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final collections = <Map<String, dynamic>>[
      {
        'title': 'Clothing',
        'image': 'https://via.placeholder.com/400x200?text=Clothing',
        'items': [
          {'title': 'T‑Shirt', 'price': '£20', 'image': 'https://via.placeholder.com/300'},
          {'title': 'Hoodie', 'price': '£35', 'image': 'https://via.placeholder.com/300'},
        ],
      },
      {
        'title': 'Accessories',
        'image': 'https://via.placeholder.com/400x200?text=Accessories',
        'items': [
          {'title': 'Cap', 'price': '£10', 'image': 'https://via.placeholder.com/300'},
          {'title': 'Bag', 'price': '£18', 'image': 'https://via.placeholder.com/300'},
        ],
      },
      {
        'title': 'Stationery',
        'image': 'https://via.placeholder.com/400x200?text=Stationery',
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(builder: (context, constraints) {
          final crossAxis = constraints.maxWidth > 800 ? 3 : (constraints.maxWidth > 500 ? 2 : 1);
          return GridView.builder(
            itemCount: collections.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxis,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.8,
            ),
            itemBuilder: (context, index) {
              final col = collections[index];
              final items = List<Map<String, String>>.from(col['items'] as List);
              return GestureDetector(
                onTap: () => openCollection(context, col['title'] as String, items),
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        col['image'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.45),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              col['title'] as String,
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Text(
                              '${items.length} items',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}