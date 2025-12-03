import 'package:flutter/material.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  void openCollection(BuildContext context, String title, List<Map<String, String>> items) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _CollectionItemsPage(title: title, items: items),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final collections = <Map<String, dynamic>>[
      {
        'title': 'Clothing',
        'image': 'assets/images/uop_tshirt.webp',
        'items': [
          {'title': 'T‑Shirt', 'price': '£20', 'image': 'assets/images/uop_tshirt.webp', 'category': 'Clothing'},
          {'title': 'Hoodie', 'price': '£35', 'image': 'assets/images/uop_hoodie.webp', 'category': 'Clothing'},
        ],
      },
      {
        'title': 'Accessories',
        'image': 'assets/images/uop_cap.webp',
        'items': [
          {'title': 'Cap', 'price': '£10', 'image': 'assets/images/uop_cap.webp', 'category': 'Accessories'},
          {'title': 'Backpack (Clearance)', 'price': '£25', 'salePrice': '£15', 'image': 'assets/images/uop_backpack.webp', 'category': 'Accessories'},
        ],
      },
      {
        'title': 'Stationery',
        'image': 'assets/images/uop_notebook.webp',
        'items': [
          {'title': 'Notebook (Clearance)', 'price': '£5', 'salePrice': '£2.50', 'image': 'assets/images/uop_notebook.webp', 'category': 'Stationery'},
          {'title': 'Pen', 'price': '£2', 'image': 'assets/images/uop_pen.webp', 'category': 'Stationery'},
        ],
      },
      {
        'title': 'SALE \n3 DAYS LEFT',
        'image': 'assets/images/uop_notebook.webp',
        'items': [
          {'title': 'Notebook (Clearance)', 'price': '£5', 'salePrice': '£2.50', 'image': 'assets/images/uop_notebook.webp', 'category': 'Stationery'},
          {'title': 'Backpack (Clearance)', 'price': '£25', 'salePrice': '£15', 'image': 'assets/images/uop_backpack.webp', 'category': 'Accessories'},
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

class _CollectionItemsPage extends StatefulWidget {
  final String title;
  final List<Map<String, String>> items;
  const _CollectionItemsPage({super.key, required this.title, required this.items});

  @override
  State<_CollectionItemsPage> createState() => _CollectionItemsPageState();
}

class _CollectionItemsPageState extends State<_CollectionItemsPage> {
  String _category = 'All';
  bool _onlySale = false;
  double _maxPrice = 100.0;
  String _sort = 'None';

  double _parsePricePounds(String s) {
    final cleaned = s.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  String _bestPrice(Map<String, String> e) =>
      (e['salePrice'] ?? '').isNotEmpty ? e['salePrice']! : (e['price'] ?? '£0');

  List<Map<String, String>> get filteredItems {
    final isSaleCollection = widget.title.toLowerCase().contains('sale');
    List<Map<String, String>> out = List.from(widget.items);

    if (isSaleCollection && _category != 'All') {
      out = out
          .where((e) => (e['category'] ?? '').toLowerCase() == _category.toLowerCase())
          .toList();
    }

    if (_onlySale) {
      out = out.where((e) => (e['salePrice'] ?? '').isNotEmpty).toList();
    }

    out = out.where((e) {
      final priceInPounds = _parsePricePounds(_bestPrice(e));
      return priceInPounds <= _maxPrice;
    }).toList();

    switch (_sort) {
      case 'Price ↑':
        out.sort((a, b) => _parsePricePounds(_bestPrice(a)).compareTo(_parsePricePounds(_bestPrice(b))));
        break;
      case 'Price ↓':
        out.sort((a, b) => _parsePricePounds(_bestPrice(b)).compareTo(_parsePricePounds(_bestPrice(a))));
        break;
      case 'Title':
        out.sort((a, b) => (a['title'] ?? '').compareTo(b['title'] ?? ''));
        break;
    }

    return out;
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    final crossAxis = isWide ? 3 : (MediaQuery.of(context).size.width > 500 ? 2 : 1);
    final isSaleCollection = widget.title.toLowerCase().contains('sale');

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: const Color(0xFF4d2963)),
      body: Column(
        children: [
          Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (isSaleCollection)
                  SizedBox(
                    width: 160,
                    child: DropdownButtonFormField<String>(
                      value: _category,
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All categories')),
                        DropdownMenuItem(value: 'Clothing', child: Text('Clothing')),
                        DropdownMenuItem(value: 'Accessories', child: Text('Accessories')),
                        DropdownMenuItem(value: 'Stationery', child: Text('Stationery')),
                      ],
                      onChanged: (v) => setState(() => _category = v ?? 'All'),
                      decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                    ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Sale only'),
                    Switch(value: _onlySale, onChanged: (v) => setState(() => _onlySale = v)),
                  ],
                ),
                SizedBox(
                  width: isWide ? 280 : 220,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Max price: £${(_maxPrice).toStringAsFixed(0)}'),
                      Slider(
                        min: 0,
                        max: 100,
                        divisions: 20,
                        value: _maxPrice,
                        label: '£${_maxPrice.toStringAsFixed(0)}',
                        onChanged: (v) => setState(() => _maxPrice = v),
                        activeColor: const Color(0xFF4d2963),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: DropdownButtonFormField<String>(
                    value: _sort,
                    items: const [
                      DropdownMenuItem(value: 'None', child: Text('No sort')),
                      DropdownMenuItem(value: 'Price ↑', child: Text('Price low-high')),
                      DropdownMenuItem(value: 'Price ↓', child: Text('Price high-low')),
                      DropdownMenuItem(value: 'Title', child: Text('Title A-Z')),
                    ],
                    onChanged: (v) => setState(() => _sort = v ?? 'None'),
                    decoration: const InputDecoration(labelText: 'Sort', border: OutlineInputBorder()),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() {
                    _category = 'All';
                    _onlySale = false;
                    _maxPrice = 100.0;
                    _sort = 'None';
                  }),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: filteredItems.isEmpty
                  ? const Center(child: Text('No items match your filters', style: TextStyle(color: Colors.grey)))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxis,
                        childAspectRatio: 0.8,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, i) {
                        final item = filteredItems[i];
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
          ),
        ],
      ),
    );
  }
}
