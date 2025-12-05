import 'package:flutter/material.dart';
import 'package:union_shop/stylesheet.dart';
import 'package:union_shop/cart.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  String _fmt(double v) => '£${v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2)}';

  @override
  Widget build(BuildContext context) {
    final cart = CartProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), backgroundColor: Styles.primary),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Summary', style: Styles.sectionTitle),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: cart.items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final it = cart.items[i];
                  return ListTile(
                    title: Text(it.title, style: Styles.productName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Qty: ${it.quantity}  •  Unit: ${_fmt(it.unitPrice)}', style: Styles.body),
                        if (it.size != null && it.size!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text('Size: ${it.size}', style: Styles.body),
                          ),
                      ],
                    ),
                    trailing: Text(_fmt(it.lineTotal), style: Styles.price),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Total', style: Styles.sectionTitle.copyWith(color: Styles.textPrimary)),
                const Spacer(),
                Text(_fmt(cart.total), style: Styles.price.copyWith(color: Colors.black)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: cart.items.isEmpty ? null : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Dummy checkout complete!')),
                      );
                      cart.clear();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Styles.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Place Order'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
