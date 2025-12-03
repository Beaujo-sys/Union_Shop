import 'package:flutter/material.dart';

class CartItem {
  final String title;
  final String image;
  final double unitPrice; // in pounds
  final int quantity;
  final String? size;

  CartItem({
    required this.title,
    required this.image,
    required this.unitPrice,
    this.quantity = 1,
    this.size,
  });

  CartItem copyWith({int? quantity}) =>
      CartItem(title: title, image: image, unitPrice: unitPrice, quantity: quantity ?? this.quantity, size: size);

  double get lineTotal => unitPrice * quantity;
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get total => _items.fold(0.0, (sum, it) => sum + it.lineTotal);

  void addItem(CartItem item) {
    // Merge same title+size as one line
    final idx = _items.indexWhere((it) => it.title == item.title && it.size == item.size);
    if (idx >= 0) {
      final existing = _items[idx];
      _items[idx] = existing.copyWith(quantity: existing.quantity + item.quantity);
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItemAt(int index) {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
    notifyListeners();
  }

  void updateQuantity(int index, int quantity) {
    if (index < 0 || index >= _items.length) return;
    if (quantity <= 0) {
      removeItemAt(index);
      return;
    }
    _items[index] = _items[index].copyWith(quantity: quantity);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// Simple inherited cart to access the same CartModel across pages.
class CartProvider extends InheritedNotifier<CartModel> {
  CartProvider({super.key, required CartModel cart, required Widget child}) : super(notifier: cart, child: child);

  static CartModel of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<CartProvider>();
    assert(provider != null, 'CartProvider not found in widget tree');
    return provider!.notifier!;
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  String _fmt(double v) => '£${v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2)}';

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    const double thumbSize = 84;
    const double iconSize = 22;            // smaller action icons
    const TextStyle labelStyle = TextStyle(fontSize: 10, color: Colors.grey);

    Widget qtyBadge(int qty) {
      return Positioned(
        right: 0,
        bottom: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF4d2963),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 1))],
          ),
          child: Text('x$qty', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart'), backgroundColor: const Color(0xFF4d2963)),
      body: AnimatedBuilder(
        animation: cart,
        builder: (context, _) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Your cart is empty', style: TextStyle(color: Colors.grey)));
          }
          final totalUnits = cart.items.fold<int>(0, (sum, it) => sum + it.quantity);
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.grey.shade100,
                child: Row(
                  children: [
                    Text('Items: ${cart.items.length}', style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 16),
                    Text('Total units: $totalUnits', style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final item = cart.items[i];
                    final thumbnail = item.image.isNotEmpty
                        ? (item.image.startsWith('assets/')
                            ? Image.asset(item.image, width: thumbSize, height: thumbSize, fit: BoxFit.cover)
                            : Image.network(item.image, width: thumbSize, height: thumbSize, fit: BoxFit.cover))
                        : const Icon(Icons.image_not_supported, size: 32);

                    // Buttons UNDER each item, smaller size
                    Widget actionBar = Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 4,
                        alignment: WrapAlignment.end,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Decrease',
                                iconSize: iconSize,
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => cart.updateQuantity(i, item.quantity - 1),
                              ),
                              const Text('Decrease', style: labelStyle),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Increase',
                                iconSize: iconSize,
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => cart.updateQuantity(i, item.quantity + 1),
                              ),
                              const Text('Increase', style: labelStyle),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Remove',
                                iconSize: iconSize,
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () => cart.removeItemAt(i),
                              ),
                              const Text('Remove', style: labelStyle),
                            ],
                          ),
                        ],
                      ),
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          leading: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SizedBox(
                                width: thumbSize,
                                height: thumbSize,
                                child: ClipRRect(borderRadius: BorderRadius.circular(8), child: thumbnail),
                              ),
                              qtyBadge(item.quantity),
                            ],
                          ),
                          title: Row(
                            children: [
                              Expanded(child: Text(item.title)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF4d2963).withOpacity(0.2)),
                                ),
                                child: Text('Qty: ${item.quantity}', style: const TextStyle(fontSize: 12)),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.size != null) Text('Size: ${item.size}'),
                              Text('Unit: ${_fmt(item.unitPrice)}'),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Product total: ${_fmt(item.lineTotal)}',
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // trailing remains removed
                        ),
                        // Buttons UNDER the tile
                        actionBar,
                      ],
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.grey.shade100, border: const Border(top: BorderSide(color: Colors.black12))),
                child: Row(
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Text(_fmt(cart.total), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}