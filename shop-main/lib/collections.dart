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
          {'title': 'T‑Shirt', 'price': '£20', 'image': 'assets/images/uop_tshirt.webp', 'category': 'Clothing', 'sizes': 'XS,S,M,L,XL,XXL'},
          {'title': 'Hoodie', 'price': '£35', 'image': 'assets/images/uop_hoodie.webp', 'category': 'Clothing', 'sizes': 'XS,S,M,L,XL,XXL'},
          {'title': 'Sweatshirt', 'price': '£30', 'image': 'assets/images/uop_sweatshirt.webp', 'category': 'Clothing', 'sizes': 'XS,S,M,L,XL,XXL'},
          {'title': 'Jacket', 'price': '£55', 'image': 'assets/images/uop_jacket.webp', 'category': 'Clothing', 'sizes': 'XS,S,M,L,XL,XXL'},
          {'title': 'Polo Shirt', 'price': '£22', 'image': 'assets/images/uop_polo_shirt.webp', 'category': 'Clothing', 'sizes': 'XS,S,M,L,XL,XXL'},
          {'title': 'Beanie', 'price': '£12', 'image': 'assets/images/uop_beanie.webp', 'category': 'Clothing', 'sizes': 'XS,S,M,L,XL,XXL'},
          {'title': 'Scarf', 'price': '£15', 'image': 'assets/images/uop_scarf.webp', 'category': 'Clothing', 'sizes': 'XS,S,M,L,XL,XXL'},
        ],
      },
      {
        'title': 'Accessories',
        'image': 'assets/images/uop_cap.webp',
        'items': [
          {'title': 'Cap', 'price': '£10', 'image': 'assets/images/uop_cap.webp', 'category': 'Accessories'},
          {'title': 'Backpack', 'price': '£25', 'image': 'assets/images/uop_backpack.webp', 'category': 'Accessories'},
          {'title': 'Lanyard', 'price': '£4', 'image': 'assets/images/uop_lanyard.webp', 'category': 'Accessories'},
          {'title': 'Keyring', 'price': '£3', 'image': 'assets/images/uop_keyring.webp', 'category': 'Accessories'},
          {'title': 'Water Bottle', 'price': '£8', 'image': 'assets/images/uop_water_bottle.webp', 'category': 'Accessories'},
          {'title': 'Tote Bag', 'price': '£6', 'image': 'assets/images/uop_tote_bag.webp', 'category': 'Accessories'},
          {'title': 'Badge', 'price': '£2', 'image': 'assets/images/uop_badge.webp', 'category': 'Accessories'},
        ],
      },
      {
        'title': 'Stationery',
        'image': 'assets/images/uop_notebook.webp',
        'items': [
          {'title': 'Notebook', 'price': '£5', 'image': 'assets/images/uop_notebook.webp', 'category': 'Stationery'},
          {'title': 'Pen', 'price': '£2', 'image': 'assets/images/uop_pen.webp', 'category': 'Stationery'},
          {'title': 'Pencil', 'price': '£1', 'image': 'assets/images/uop_pencil.webp', 'category': 'Stationery'},
          {'title': 'Highlighter', 'price': '£1.50', 'image': 'assets/images/uop_highlighter.webp', 'category': 'Stationery'},
          {'title': 'Folder', 'price': '£3', 'image': 'assets/images/uop_folder.webp', 'category': 'Stationery'},
          {'title': 'Sticky Notes', 'price': '£2.50', 'image': 'assets/images/uop_sticky_notes.webp', 'category': 'Stationery'},
          {'title': 'Ruler', 'price': '£7', 'image': 'assets/images/uop_ruler.webp', 'category': 'Stationery'},
        ],
      },
      {
        'title': 'SALE',
        'image': 'assets/images/uop_notebook.webp',
        'items': [
          {'title': 'Notebook', 'price': '£5', 'salePrice': '£2.50', 'image': 'assets/images/uop_notebook.webp', 'category': 'Stationery'},
          {'title': 'Backpack', 'price': '£25', 'salePrice': '£15', 'image': 'assets/images/uop_backpack.webp', 'category': 'Accessories'},
          {'title': 'Hoodie', 'price': '£35', 'salePrice': '£25', 'image': 'assets/images/uop_hoodie.webp', 'category': 'Clothing'},
          {'title': 'T‑Shirt', 'price': '£20', 'salePrice': '£12', 'image': 'assets/images/uop_tshirt.webp', 'category': 'Clothing'},
          {'title': 'Cap', 'price': '£10', 'salePrice': '£6', 'image': 'assets/images/uop_cap.webp', 'category': 'Accessories'},
          {'title': 'Pen', 'price': '£2', 'salePrice': '£1', 'image': 'assets/images/uop_pen.webp', 'category': 'Stationery'},
        ],
      },
    ];

    // Merge sale prices into their respective collections based on title
    Map<String, String> saleLookup = {};
    final saleCollection = collections.firstWhere(
      (c) => (c['title'] as String).toLowerCase().contains('sale'),
      orElse: () => {},
    );
    if (saleCollection is Map<String, dynamic>) {
      for (final item in (saleCollection['items'] as List).cast<Map<String, String>>()) {
        final titleKey = (item['title'] ?? '').toLowerCase().replaceAll(RegExp(r'\s+sale$'), '');
        final salePrice = item['salePrice'] ?? '';
        if (salePrice.isNotEmpty) {
          saleLookup[titleKey] = salePrice;
        }
      }
    }

    for (final collection in collections) {
      if ((collection['title'] as String).toLowerCase().contains('sale')) continue;
      final items = (collection['items'] as List).cast<Map<String, String>>();
      for (final item in items) {
        final key = (item['title'] ?? '').toLowerCase();
        final salePrice = saleLookup[key];
        if (salePrice != null && salePrice.isNotEmpty) {
          item['salePrice'] = salePrice;
        }
      }
    }

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
  static const int pageSize = 6;
  int currentPage = 1;

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
      out = out.where((e) => (e['category'] ?? '').toLowerCase() == _category.toLowerCase()).toList();
    }

    if (_onlySale) {
      out = out.where((e) => (e['salePrice'] ?? '').isNotEmpty).toList();
    }

    out = out.where((e) => _parsePricePounds(_bestPrice(e)) <= _maxPrice).toList();

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

  List<Map<String, String>> get pagedItems {
    final items = filteredItems;
    final start = (currentPage - 1) * pageSize;
    final end = (start + pageSize).clamp(0, items.length);
    if (start >= items.length) return [];
    return items.sublist(start, end);
  }

  int get totalPages {
    final count = filteredItems.length;
    if (count == 0) return 1;
    return ((count + pageSize - 1) ~/ pageSize);
  }

  void goToPage(int p) {
    setState(() {
      currentPage = p.clamp(1, totalPages);
    });
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
                      onChanged: (v) {
                        _category = v ?? 'All';
                        currentPage = 1;
                        setState(() {});
                      },
                      decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                    ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Sale only'),
                    Switch(
                      value: _onlySale,
                      onChanged: (v) {
                        _onlySale = v;
                        currentPage = 1;
                        setState(() {});
                      },
                    ),
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
                        onChanged: (v) {
                          _maxPrice = v;
                          currentPage = 1;
                          setState(() {});
                        },
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
                    onChanged: (v) {
                      _sort = v ?? 'None';
                      currentPage = 1;
                      setState(() {});
                    },
                    decoration: const InputDecoration(labelText: 'Sort', border: OutlineInputBorder()),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _category = 'All';
                    _onlySale = false;
                    _maxPrice = 100.0;
                    _sort = 'None';
                    currentPage = 1;
                    setState(() {});
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
          if (filteredItems.length >= pageSize)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: currentPage > 1 ? () => goToPage(currentPage - 1) : null,
                    child: const Text('Prev'),
                  ),
                  for (int p = 1; p <= totalPages; p++)
                    TextButton(
                      onPressed: () => goToPage(p),
                      style: TextButton.styleFrom(
                        foregroundColor: p == currentPage ? const Color(0xFF4d2963) : Colors.black,
                      ),
                      child: Text('$p'),
                    ),
                  OutlinedButton(
                    onPressed: currentPage < totalPages ? () => goToPage(currentPage + 1) : null,
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: pagedItems.isEmpty
                  ? const Center(child: Text('No items match your filters', style: TextStyle(color: Colors.grey)))
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxis,
                        childAspectRatio: 0.8,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      itemCount: pagedItems.length,
                      itemBuilder: (context, i) {
                        final item = pagedItems[i];
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
                                          return Image.asset(img, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]));
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
