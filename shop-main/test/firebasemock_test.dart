import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/cart_repository.dart';
import 'package:union_shop/cart.dart';
class TestCartRepository extends CartRepository {
  TestCartRepository() : super(firestore: null);

  @override
  Future<void> saveCart(CartModel cart) async {}

  @override
  Future<void> loadCartInto(CartModel cart) async {}

  @override
  Future<void> clearUserCart() async {}
}

