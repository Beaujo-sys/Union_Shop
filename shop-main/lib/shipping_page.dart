import 'package:flutter/material.dart';

class ShippingPage extends StatelessWidget {
  const ShippingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Information'),
        backgroundColor: const Color(0xFF4d2963),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 12),
            Text('Shipping', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Shipping cost varies depending on the destination with all orders in the UK eligible for free shipping on orders over £30.', style: TextStyle(color: Colors.grey)), // fill in shipping details here

            SizedBox(height: 24),
            Text('Delivery Times', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Delivery usually takes 3-5 business days within the UK.', style: TextStyle(color: Colors.grey)), // fill in

            SizedBox(height: 24),
            Text('Returns & Exchanges', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Products can be returned within 14 days of receipt.', style: TextStyle(color: Colors.grey)), // fill in
          ],
        ),
      ),
    );
  }
}