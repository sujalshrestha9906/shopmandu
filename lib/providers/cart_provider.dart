import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:shopmandu/main.dart';
import 'package:shopmandu/model/cart_item.dart';

import '../model/product.dart';

final cartProvider = StateNotifierProvider<CartProvider, List<CartItem>>(
    (ref) => CartProvider(ref.watch(box1)));

class CartProvider extends StateNotifier<List<CartItem>> {
  CartProvider(super.state);

  String add(Product product) {
    if (state.isEmpty) {
      final newCart = CartItem(
          id: product.id,
          image: product.image,
          price: product.price,
          product_name: product.product_name,
          quantity: 1);
      Hive.box<CartItem>('carts').add(newCart);
      state = [newCart];
      return 'Sucessfully added';
    } else {
      final prev = state.firstWhere((element) => element.id == product.id,
          orElse: () => CartItem(
              id: '',
              image: '',
              price: 0,
              product_name: 'no-data',
              quantity: 0));

      if (prev.product_name == 'no-data') {
        final newCart = CartItem(
            id: product.id,
            image: product.image,
            price: product.price,
            product_name: product.product_name,
            quantity: 1);
        Hive.box<CartItem>('carts').add(newCart);
        state = [newCart];
        return 'Sucessfully added';
      } else {
        return 'Already added';
      }
    }
  }

  void remove(CartItem cartItem) {
    cartItem.delete();
    state.remove(cartItem);
    state = [...state];
  }

  void singleAdd(CartItem cartItem) {
    cartItem.quantity = cartItem.quantity + 1;
    cartItem.save();
    state = [
      for (final c in state)
        if (c == cartItem) cartItem else c
    ];
  }

  void singleRemove(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity = cartItem.quantity - 1;
      cartItem.save();
      state = [
        for (final c in state)
          if (c == cartItem) cartItem else c
      ];
    }
  }

  int get total {
    int total = 0;
    for (final cart in state) {
      total += cart.price * cart.quantity;
    }
    return total;
  }
}
