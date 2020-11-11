import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shoppLavibe/models/produtos.dart';

class CarrinhoItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CarrinhoItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Carrinho with ChangeNotifier {
  Map<String, CarrinhoItem> _items = {};

  Map<String, CarrinhoItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Produtos product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CarrinhoItem(
          id: existingItem.id,
          productId: product.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CarrinhoItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          title: product.title,
          price: product.price,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removerCarrinho(productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (existingItem) => CarrinhoItem(
          id: existingItem.id,
          productId: productId,
          title: existingItem.title,
          quantity: existingItem.quantity - 1,
          price: existingItem.price,
        ),
      );
    }

    notifyListeners();
  }
}
