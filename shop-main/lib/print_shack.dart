import 'package:flutter/material.dart';
import 'package:union_shop/stylesheet.dart';
import 'package:union_shop/cart.dart';

class PrintShackPage extends StatefulWidget {
  const PrintShackPage({super.key});

  @override
  State<PrintShackPage> createState() => _PrintShackPageState();
}

class _PrintShackPageState extends State<PrintShackPage> {
  static const double _hoodiePrice = 35.0;

  final TextEditingController _textCtrl = TextEditingController();
  final TextEditingController _qtyCtrl = TextEditingController(text: '1');
  String _size = 'M';
  int _quantity = 1;

  @override
  void dispose() {
    _textCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  void _setQuantity(int q) {
    final newQ = q < 1 ? 1 : q;
    setState(() {
      _quantity = newQ;
      _qtyCtrl.text = '$newQ';
    });
  }

  String _fmt(double v) => '£${v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2)}';

  void _addToCart() {
    final text = _textCtrl.text.trim();
    final title = text.isEmpty ? 'Custom Hoodie' : 'Custom Hoodie – "$text"';
    final cart = CartProvider.of(context);
    cart.addItem(CartItem(
      title: title,
      image: 'assets/images/uop_hoodie.webp',
      unitPrice: _hoodiePrice,
      quantity: _quantity,
      size: _size,
    ));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added $_quantity × $title')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Shack'),
        backgroundColor: const Color(0xFF4d2963),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text('Print Shack', style: Styles.pageHeading),
            const SizedBox(height: 8),
            const Text(
              'Personalisation & print services for apparel and gifts.\n\n'
              'Add names or numbers to selected items.\n'
              'Turnaround times vary based on design complexity and volume.\n\n'
              'For enquiries and quotes, please email: up2281726@myport.ac.uk',
              style: Styles.bodyBlack,
            ),
            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Styles.primary.withValues(alpha: 0.15)),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          'assets/images/uop_hoodie.webp',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Icon(Icons.checkroom, size: 48, color: Colors.grey));
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Custom Hoodie', style: Styles.title.copyWith(fontSize: 20)),
                            const SizedBox(height: 4),
                            Text(_fmt(_hoodiePrice), style: Styles.price.copyWith(color: Colors.black)),
                            const SizedBox(height: 8),
                            Text('Add your own text to a comfy hoodie.', style: Styles.bodyBlack),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text('Personalised Text', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _textCtrl,
                    maxLength: 20,
                    decoration: InputDecoration(
                      hintText: 'e.g. “PORTSMOUTH 24”',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Size', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              initialValue: _size,
                              items: const [
                                DropdownMenuItem(value: 'XS', child: Text('XS')),
                                DropdownMenuItem(value: 'S', child: Text('S')),
                                DropdownMenuItem(value: 'M', child: Text('M')),
                                DropdownMenuItem(value: 'L', child: Text('L')),
                                DropdownMenuItem(value: 'XL', child: Text('XL')),
                                DropdownMenuItem(value: 'XXL', child: Text('XXL')),
                              ],
                              onChanged: (v) => setState(() => _size = v ?? _size),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Quantity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  tooltip: 'Decrease',
                                  onPressed: () => _setQuantity(_quantity - 1),
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                SizedBox(
                                  width: 64,
                                  child: TextFormField(
                                    controller: _qtyCtrl,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    onChanged: (v) {
                                      final n = int.tryParse(v);
                                      if (n != null && n > 0) {
                                        _quantity = n;
                                      }
                                    },
                                    onEditingComplete: () {
                                      final n = int.tryParse(_qtyCtrl.text) ?? _quantity;
                                      _setQuantity(n);
                                      FocusScope.of(context).unfocus();
                                    },
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Increase',
                                  onPressed: () => _setQuantity(_quantity + 1),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _addToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Add to cart'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
