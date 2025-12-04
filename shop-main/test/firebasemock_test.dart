import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/cart_repository.dart';
import 'package:union_shop/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
class TestCartRepository extends CartRepository {
  TestCartRepository() : super(firestore: null);

  @override
  Future<void> saveCart(CartModel cart) async {}

  @override
  Future<void> loadCartInto(CartModel cart) async {}

  @override
  Future<void> clearUserCart() async {}
}

void main() {
  test('TestCartRepository provides no-op methods', () async {
    final repo = TestCartRepository();
    final cart = CartModel(repo: repo, authState: const Stream<User?>.empty());
    await repo.saveCart(cart);
    await repo.loadCartInto(cart);
    await repo.clearUserCart();
    expect(cart.items.length, isNotNull); 
  });
}

