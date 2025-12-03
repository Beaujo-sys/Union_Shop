import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xFF4d2963),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 12),
            Text('Our Story', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('', style: TextStyle(color: Colors.grey)), // fill in

            SizedBox(height: 24),
            Text('Mission', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('', style: TextStyle(color: Colors.grey)), // fill in

            SizedBox(height: 24),
            Text('Team', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('', style: TextStyle(color: Colors.grey)), // fill in

            SizedBox(height: 24),
            Text('Contact', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('', style: TextStyle(color: Colors.grey)), // fill in
          ],
        ),
      ),
    );
  }
}