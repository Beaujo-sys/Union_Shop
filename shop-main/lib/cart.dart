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
    const double thumbSize = 96;   // much bigger thumbnail
    const double iconSize = 36;    // much bigger action icons
    const TextStyle labelStyle = TextStyle(fontSize: 12, color: Colors.grey);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart'), backgroundColor: const Color(0xFF4d2963)),
      body: AnimatedBuilder(
        animation: cart,
        builder: (context, _) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Your cart is empty', style: TextStyle(color: Colors.grey)));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final item = cart.items[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      leading: item.image.isNotEmpty
                          ? (item.image.startsWith('assets/')
                              ? Image.asset(item.image, width: thumbSize, height: thumbSize, fit: BoxFit.cover)
                              : Image.network(item.image, width: thumbSize, height: thumbSize, fit: BoxFit.cover))
                          : const Icon(Icons.image_not_supported, size: 40),
                      title: Text(item.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.size != null) Text('Size: ${item.size}'),
                          Text('Unit: ${_fmt(item.unitPrice)}'),
                        ],
                      ),
                      trailing: SizedBox(
                        width: 220, // give space for big icons + labels
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(_fmt(item.lineTotal), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    IconButton(
                                      tooltip: 'Decrease',
                                      iconSize: iconSize,
                                      icon: const Icon(Icons.remove_circle_outline),
                                      onPressed: () => cart.updateQuantity(i, item.quantity - 1),
                                    ),
                                    const Text('Decrease', style: labelStyle),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  children: [
                                    IconButton(
                                      tooltip: 'Increase',
                                      iconSize: iconSize,
                                      icon: const Icon(Icons.add_circle_outline),
                                      onPressed: () => cart.updateQuantity(i, item.quantity + 1),
                                    ),
                                    const Text('Increase', style: labelStyle),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  children: [
                                    IconButton(
                                      tooltip: 'Remove',
                                      iconSize: iconSize,
                                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                      onPressed: () => cart.removeItemAt(i),
                                    ),
                                    const Text('Remove', style: labelStyle),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('Qty: ${item.quantity}', style: const TextStyle(fontSize: 14, color: Colors.black54)),
                          ],
                        ),
                      ),
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