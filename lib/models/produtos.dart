import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shoppLavibe/utils/constants.dart';

class Produtos with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  // List<String> fotos;
  bool isFavorite;

  Produtos(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      // @required this.fotos,
      this.isFavorite = false});

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

//validar a favoritos
  Future<void> validarFavorite(String token, String userID) async {
    _toggleFavorite();
    final String url =
        '${Constants.BASE_API_URL}/userFavorites/$userID/$id.json?auth=$token';
    //isFavorite = !isFavorite;
    //notificar quando ocorrer mudanças
    notifyListeners();
    try {
      final response = await http.put(
        url,
        body: json.encode(isFavorite),
      );

      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (error) {
      _toggleFavorite();
    }
  }
}
