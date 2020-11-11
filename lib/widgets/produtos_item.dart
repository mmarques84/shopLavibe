import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppLavibe/models/produtos.dart';
import 'package:shoppLavibe/providers/produtos_providers.dart';
import 'package:shoppLavibe/utils/app_routers.dart';

class ProdutosItem extends StatelessWidget {
  final Produtos produto;

  ProdutosItem(this.produto);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(produto.imageUrl),
      ),
      title: Text(produto.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.ProdutosForm, arguments: produto);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Excluir Produto'),
                    content: Text('Tem certeza?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Não'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      FlatButton(
                        child: Text('Sim'),
                        onPressed: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  ),
                ).then((value) {
                  if (value) {
                    Provider.of<ProdutosProviders>(context, listen: false)
                        .deleteProduct(produto.id);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
