import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shoppLavibe/models/produtos.dart';
import 'package:http/http.dart' as http;
import 'package:shoppLavibe/utils/constants.dart';

class ProdutosProviders with ChangeNotifier {
  final String _baseurl = '${Constants.BASE_API_URL}/produto';
  List<Produtos> _items = [];

  String _token;
  String _userId;

  ProdutosProviders([this._token, this._userId, this._items = const []]);

  List<Produtos> get items => [..._items];

  List<Produtos> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  int get itemsCount {
    return _items.length;
  }

  List<Produtos> get isFavorite {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> loadProducts() async {
    final response = await http.get("$_baseurl.json?auth=$_token");
    Map<String, dynamic> data = json.decode(response.body);

    final favResponse = await http.get(
        "${Constants.BASE_API_URL}/userFavorites/$_userId.json?auth=$_token");
    final favMap = json.decode(favResponse.body);

    _items.clear();
    if (data != null) {
      data.forEach((produtoId, produtoData) {
        final isFavorite = favMap == null ? false : favMap[produtoId] ?? false;
        _items.add(Produtos(
          id: produtoId,
          title: produtoData['title'],
          description: produtoData['description'],
          price: produtoData['price'],
          imageUrl: produtoData['imageUrl'],
          //  fotos: produtoData['fotos'],
          isFavorite: isFavorite,
        ));
      });
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> addProduct(Produtos newProduct) async {
    final response = await http.post(
      "$_baseurl.json?auth=$_token",
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        // 'fotos': newProduct.fotos,
        'isFavorite': newProduct.isFavorite
      }),
    );

    _items.add(Produtos(
      id: json
          .decode(response.body)['name'], //Random().nextDouble().toString(),
      title: newProduct.title,
      description: newProduct.description,
      price: newProduct.price,
      //  fotos: newProduct.fotos,
      imageUrl: newProduct.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Produtos product) async {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      await http.patch(
        "$_baseurl/${product.id}.json?auth=$_token",
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          //'fotos': product.fotos,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response =
          await http.delete("$_baseurl/${product.id}.json?auth=$_token");

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException('Ocorreu um erro na exclusão do produto.');
      }
    }
  }

  void addProduto(Produtos produtos) {
    _items.add(produtos);
    //Apos qualquer açao vai ser notificado com notifyListeners()
    notifyListeners();
  }
}
