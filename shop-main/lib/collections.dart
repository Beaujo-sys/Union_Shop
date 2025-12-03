import 'package:flutter/material.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  void openCollection(BuildContext context, String title, List<Map<String, String>> items) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Scaffold(
        appBar: AppBar(title: Text(title), backgroundColor: const Color(0xFF4d2963)),
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
                      onTap: () {
                        final route = item['route'];
                        final target = (route?.isNotEmpty == true) ? route! : '/product';
                        Navigator.pushNamed(context, target, arguments: item);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Builder(builder: (_) {
                                      final img = item['image'] ?? '';
                                      if (img.isEmpty) return Container(color: Colors.grey[300]);
                                      return Image.asset(img, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(color: Colors.grey[300]));
                                    }),
                                    // Sale badge for items with a salePrice
                                    if ((item['salePrice'] ?? '').isNotEmpty)
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(4)),
                                          child: const Text('SALE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                        ),
                                      ),
                                  ],
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
                                  // If salePrice exists show original struck-through and sale price
                                  if ((item['salePrice'] ?? '').isNotEmpty)
                                    Row(
                                      children: [
                                        Text(item['price'] ?? '', style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough)),
                                        const SizedBox(width: 8),
                                        Text(item['salePrice'] ?? '', style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                      ],
                                    )
                                  else
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
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final collections = <Map<String, dynamic>>[
      {
        'title': 'Clothing',
        'image': 'assets/images/uop_tshirt.webp',
        'items': [
          {'title': 'T‑Shirt', 'price': '£20', 'image': 'assets/images/uop_tshirt.webp'},
          {'title': 'Hoodie', 'price': '£35', 'image': 'assets/images/uop_hoodie.webp'},
        ],
      },
      {
        'title': 'Accessories',
        'image': 'assets/images/uop_cap.webp',
        'items': [
          {'title': 'Cap', 'price': '£10', 'image': 'assets/images/uop_cap.webp'},
          {'title': 'Backpack (Clearance)', 'price': '£25', 'salePrice': '£15', 'image': 'assets/images/uop_backpack.webp'},
        ],
      },
      {
        'title': 'Stationery',
        'image': 'assets/images/uop_notebook.webp',
        'items': [
          {'title': 'Notebook (Clearance)', 'price': '£5', 'salePrice': '£2.50', 'image': 'assets/images/uop_notebook.webp'},
          {'title': 'Pen', 'price': '£2', 'image': 'assets/images/uop_pen.webp'},
        ],
      },

      // New collection: On Sale
      {
        'title': 'SALE \n3 DAYS LEFT',
        'image': 'assets/images/uop_notebook.webp',
        'items': [
          // include salePrice to mark item as on sale
          {'title': 'Notebook (Clearance)', 'price': '£5', 'salePrice': '£2.50', 'image': 'assets/images/uop_notebook.webp'},
          {'title': 'Backpack (Clearance)', 'price': '£25', 'salePrice': '£15', 'image': 'assets/images/uop_backpack.webp'},
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
                      Image.asset(
                        col['image'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
                      ),
                      Container(color: Colors.black.withOpacity(0.45)),
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
                            Text('${items.length} items', style: const TextStyle(color: Colors.white70)),
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
