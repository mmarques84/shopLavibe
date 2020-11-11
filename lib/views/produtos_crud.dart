import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppLavibe/providers/produtos_providers.dart';
import 'package:shoppLavibe/utils/app_routers.dart';
import 'package:shoppLavibe/widgets/app_drawer.dart';
import 'package:shoppLavibe/widgets/produtos_item.dart';

class ProdutosCrud extends StatelessWidget {
  Future<void> _refreshTela(BuildContext context) {
    return Provider.of<ProdutosProviders>(context, listen: false)
        .loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final produtosData = Provider.of<ProdutosProviders>(context);
    final _produtos = produtosData.items;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.ProdutosForm);
            },
          )
        ],
        title: Text('Gerenciamentos Produtos'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshTela(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: produtosData.itemsCount,
            itemBuilder: (ctx, i) => Column(
              children: <Widget>[
                ProdutosItem(_produtos[i]),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
