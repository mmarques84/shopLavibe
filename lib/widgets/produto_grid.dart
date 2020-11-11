import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shoppLavibe/providers/produtos_providers.dart';
import 'package:shoppLavibe/widgets/produtos_grid_item.dart';

class ProdutosGrid extends StatelessWidget {
  final bool mostrarFavorito;
  ProdutosGrid(this.mostrarFavorito);
  @override
  Widget build(BuildContext context) {
    final produtosProviders = Provider.of<ProdutosProviders>(context);
    final produtos = mostrarFavorito
        ? produtosProviders.favoriteItems
        : produtosProviders.items;
    return GridView.builder(
      itemCount: produtos.length,
      padding: EdgeInsets.all(10),
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
          value: produtos[i], child: ProdutosGridItem()),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
