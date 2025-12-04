import 'package:flutter/material.dart';
import 'package:union_shop/stylesheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_repository.dart';
import 'dart:async' as async;

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
  final CartRepository _repo;
  async.StreamSubscription<User?>? _authSub;

  // Allow injecting repo and auth stream (tests will pass a repo with null Firestore and empty auth)
  CartModel({CartRepository? repo, async.Stream<User?>? authState})
      : _repo = repo ?? CartRepository() {
    final stream = authState ?? FirebaseAuth.instance.authStateChanges();
    _authSub = stream.listen((user) async {
      // When a user signs in, load their remote cart into the model.
      if (user != null) {
        await _repo.loadCartInto(this);
      } else {
        // On sign-out, clear local cart and ensure remote cart is cleared.
        _items.clear();
        notifyListeners();
        await _repo.clearUserCart();
      }
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  List<CartItem> get items => List.unmodifiable(_items);

  double get total => _items.fold(0.0, (sum, it) => sum + it.lineTotal);

  void addItem(CartItem item) {
    final idx = _items.indexWhere((it) => it.title == item.title && it.size == item.size);
    if (idx >= 0) {
      final existing = _items[idx];
      _items[idx] = existing.copyWith(quantity: existing.quantity + item.quantity);
    } else {
      _items.add(item);
    }
    notifyListeners();
    _persistIfSignedIn();
  }

  void removeItemAt(int index) {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
    notifyListeners();
    _persistIfSignedIn();
  }

  void updateQuantity(int index, int quantity) {
    if (index < 0 || index >= _items.length) return;
    if (quantity <= 0) {
      removeItemAt(index);
      return;
    }
    _items[index] = _items[index].copyWith(quantity: quantity);
    notifyListeners();
    _persistIfSignedIn();
  }

  void clear() {
    _items.clear();
    notifyListeners();
    _persistIfSignedIn(); // clears remote cart for signed-in users
  }

  Future<void> _persistIfSignedIn() async {
    // Save to Firestore only when user is signed in
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _repo.saveCart(this);
      }
    } catch (_) {
      // In tests where Firebase isn't initialized, silently skip persistence.
    }
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
    const double iconSize = 22;
    final TextStyle labelStyle = Styles.uiLabel;

    // Quantity badge uses Styles palette
    Widget qtyBadge(int qty) {
      return Positioned(
        right: 0,
        bottom: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Styles.surface, // was Styles.primary
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Styles.primary.withOpacity(0.25)),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 1))],
          ),
          child: Text(
            'x$qty',
            style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold), // numbers black
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart'), backgroundColor: Styles.primary),
      body: AnimatedBuilder(
        animation: cart,
        builder: (context, _) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          final totalUnits = cart.items.fold<int>(0, (sum, it) => sum + it.quantity);

          return Column(
            children: [
              // Summary header: Items and Total units styled via Styles
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Styles.surface,
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Styles.body.copyWith(color: Styles.textPrimary),
                        children: [
                          const TextSpan(text: 'Items: '),
                          TextSpan(
                            text: '${cart.items.length}',
                            style: Styles.body.copyWith(
                              color: Colors.black, // numbers black
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    RichText(
                      text: TextSpan(
                        style: Styles.body.copyWith(color: Styles.textPrimary),
                        children: [
                          const TextSpan(text: 'Total units: '),
                          TextSpan(
                            text: '$totalUnits',
                            style: Styles.body.copyWith(
                              color: Colors.black, // numbers black
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                              Expanded(child: Text(item.title, style: Styles.productName)),
                              // Qty chip styled from Styles
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Styles.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Styles.primary.withOpacity(0.25)),
                                ),
                                child: Text('Qty: ${item.quantity}', style: Styles.uiLabel.copyWith(color: Styles.textPrimary)),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.size != null) Text('Size: ${item.size}', style: Styles.body),
                              Text('Unit: ${_fmt(item.unitPrice)}', style: Styles.body),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Product total: ',
                                            style: Styles.body.copyWith(color: Styles.textPrimary),
                                          ),
                                          TextSpan(
                                            text: _fmt(item.lineTotal),
                                            style: Styles.price.copyWith(color: Colors.black), // numbers black
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Action bar (kept; uses labelStyle from Styles)
                        Padding(
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
                                    icon: const Icon(Icons.remove_circle_outline, color: Styles.textPrimary),
                                    onPressed: () => cart.updateQuantity(i, item.quantity - 1),
                                  ),
                                  Text('Decrease', style: labelStyle),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Increase',
                                    iconSize: iconSize,
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(Icons.add_circle_outline, color: Styles.textPrimary),
                                    onPressed: () => cart.updateQuantity(i, item.quantity + 1),
                                  ),
                                  Text('Increase', style: labelStyle),
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
                                  Text('Remove', style: labelStyle),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Cart total styled from Styles
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Styles.surface,
                  border: Border(top: BorderSide(color: Styles.primary.withOpacity(0.1))),
                ),
                child: Row(
                  children: [
                    Text('Total', style: Styles.sectionTitle.copyWith(color: Styles.textPrimary)),
                    const Spacer(),
                    Text(
                      _fmt(cart.total),
                      style: Styles.price.copyWith(color: Colors.black), // numbers black
                    ),
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