import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppLavibe/models/carrinho.dart';
import 'package:shoppLavibe/providers/produtos_providers.dart';
import 'package:shoppLavibe/utils/app_routers.dart';
import 'package:shoppLavibe/widgets/app_drawer.dart';
import 'package:shoppLavibe/widgets/bagde.dart';
import 'package:shoppLavibe/widgets/produto_grid.dart';

enum OpcaoFilter {
  Favorito,
  ALL,
}

class ProdutoTela extends StatefulWidget {
  @override
  _ProdutoTelaState createState() => _ProdutoTelaState();
}

class _ProdutoTelaState extends State<ProdutoTela> {
  bool _mostrartodo = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    //precisa colocar listen: false, porque nao esta dentro do context
    Provider.of<ProdutosProviders>(context, listen: false)
        .loadProducts()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha loja'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (OpcaoFilter selectedValue) {
                setState(() {
                  if (selectedValue == OpcaoFilter.Favorito) {
                    //  produtosProviders.mostrarUmfavoritos();
                    _mostrartodo = true;
                  } else {
                    // produtosProviders.mostrartodosFavoritos();
                    _mostrartodo = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Somente Favoritos'),
                      value: OpcaoFilter.Favorito,
                    ),
                    PopupMenuItem(
                      child: Text('Todos'),
                      value: OpcaoFilter.ALL,
                    )
                  ]),
          Consumer<Carrinho>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CarrinhoTela);
              },
            ),
            builder: (_, carrinho, child) => Badge(
              value: carrinho.itemsCount.toString(),
              child: child,
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProdutosGrid(_mostrartodo),
      drawer: AppDrawer(),
    );
  }
}
