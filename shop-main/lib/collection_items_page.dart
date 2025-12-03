import 'package:flutter/material.dart';

class CollectionItemsPage extends StatelessWidget {
  final String title;
  final List<Map<String, String>> items;

  const CollectionItemsPage({super.key, required this.title, required this.items});

  void openProduct(BuildContext context) {
    Navigator.pushNamed(context, '/product');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF4d2963),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: items.isEmpty
            ? const Center(child: Text('No items in this collection', style: TextStyle(color: Colors.grey)))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : (MediaQuery.of(context).size.width > 500 ? 2 : 1),
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  return GestureDetector(
                    onTap: () => openProduct(context),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                              child: Image.network(
                                item['image'] ?? '',
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['title'] ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(item['price'] ?? '', style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}