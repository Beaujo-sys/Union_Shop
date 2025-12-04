import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart.dart';

// Make Firestore purely injected. If null, all methods become no-ops.
class CartRepository {
  final FirebaseFirestore? _db;

  CartRepository({FirebaseFirestore? firestore}) : _db = firestore; // CHANGED

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  Future<void> saveCart(CartModel cart) async {
    final uid = _uid;
    final db = _db;
    if (uid == null || db == null) return;

    final batch = db.batch();
    final col = db.collection('users').doc(uid).collection('cart');

    final existing = await col.get();
    for (final doc in existing.docs) {
      batch.delete(doc.reference);
    }

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
    final db = _db;
    if (uid == null || db == null) return;

    final col = db.collection('users').doc(uid).collection('cart');
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
    final db = _db;
    if (uid == null || db == null) return;

    final col = db.collection('users').doc(uid).collection('cart');
    final batch = db.batch();
    final snap = await col.get();
    for (final d in snap.docs) {
      batch.delete(d.reference);
    }
    await batch.commit();
  }
}