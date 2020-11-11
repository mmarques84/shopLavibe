import 'dart:convert';
import 'package:shoppLavibe/models/carrinho.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shoppLavibe/utils/constants.dart';

class Pedido {
  final String id;
  final double total;
  final List<CarrinhoItem> products;
  final DateTime date;

  Pedido({
    this.id,
    this.total,
    this.products,
    this.date,
  });
}

class Pedidos with ChangeNotifier {
  final String _baseUrl = '${Constants.BASE_API_URL}/pedido';
  List<Pedido> _items = [];

  String _token;
  String _userId;

  Pedidos([this._token, this._userId, this._items = const []]);

  List<Pedido> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadPedidos() async {
    List<Pedido> loadedItems = [];
    final response = await http.get("$_baseUrl/$_userId.json?auth=$_token");
    Map<String, dynamic> data = json.decode(response.body);

    if (data != null) {
      data.forEach((orderId, orderData) {
        loadedItems.add(
          Pedido(
            id: orderId,
            total: orderData['total'],
            date: DateTime.parse(orderData['date']),
            products: (orderData['products'] as List<dynamic>).map((item) {
              return CarrinhoItem(
                id: item['id'],
                price: item['price'],
                productId: item['productId'],
                quantity: item['quantity'],
                title: item['title'],
              );
            }).toList(),
          ),
        );
      });
      notifyListeners();
    }

    _items = loadedItems.reversed.toList();
    return Future.value();
  }

  Future<void> addPedido(Carrinho carrinho) async {
    final date = DateTime.now();
    final response = await http.post(
      "$_baseUrl/$_userId.json?auth=$_token",
      body: json.encode({
        'total': carrinho.totalAmount,
        'date': date.toIso8601String(),
        'products': carrinho.items.values
            .map((cartItem) => {
                  'id': cartItem.id,
                  'productId': cartItem.productId,
                  'title': cartItem.title,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList()
      }),
    );
    _items.insert(
      0,
      Pedido(
        id: json.decode(response.body)['name'],
        total: carrinho.totalAmount,
        date: DateTime.now(),
        products: carrinho.items.values.toList(),
      ),
    );

    notifyListeners();
  }

  toStringAsFixed(int i) {}
}
