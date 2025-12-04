import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart.dart';

class CartRepository {
  final _db = FirebaseFirestore.instance;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> saveCart(CartModel cart) async {
    final uid = _uid;
    if (uid == null) return; // only save for signed-in users
    final batch = _db.batch();
    final col = _db.collection('users').doc(uid).collection('cart');

    // Clear old items
    final existing = await col.get();
    for (final doc in existing.docs) {
      batch.delete(doc.reference);
    }

    // Write current items
    for (final item in cart.items) {
      final doc = col.doc('${item.title}:${item.size ?? ''}');
      batch.set(doc, {
        'title': item.title,
        'image': item.image,
        'unitPrice': item.unitPrice,
        'quantity': item.quantity,
        'size': item.size,
      });
    }

    await batch.commit();
  }

  Future<void> loadCartInto(CartModel cart) async {
    final uid = _uid;
    if (uid == null) return; // nothing to load for guests
    final col = _db.collection('users').doc(uid).collection('cart');
    final snap = await col.get();

    cart.clear();
    for (final doc in snap.docs) {
      final data = doc.data();
      cart.addItem(CartItem(
        title: data['title'] as String,
        image: data['image'] as String? ?? '',
        unitPrice: (data['unitPrice'] as num).toDouble(),
        quantity: (data['quantity'] as num).toInt(),
        size: data['size'] as String?,
      ));
    }
  }

  Future<void> clearUserCart() async {
    final uid = _uid;
    if (uid == null) return;
    final col = _db.collection('users').doc(uid).collection('cart');
    final batch = _db.batch();
    final snap = await col.get();
    for (final d in snap.docs) {
      batch.delete(d.reference);
    }
    await batch.commit();
  }
}