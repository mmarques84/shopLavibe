import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppLavibe/models/carrinho.dart';
import 'package:shoppLavibe/models/produtos.dart';
import 'package:shoppLavibe/providers/auth.dart';
import 'package:shoppLavibe/utils/app_routers.dart';

class ProdutosGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //listen nao vai mudar o objetos
    final Produtos produto = Provider.of<Produtos>(context, listen: false);
    final Carrinho carrinho = Provider.of<Carrinho>(context, listen: false);
    final Auth auth = Provider.of(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.ProdutosDetalhes,
              arguments: produto,
            );
          },
          child: FadeInImage(
            placeholder: AssetImage('assets\images\product-placeholder.png'),
            image: NetworkImage(
              produto.imageUrl,
            ),
            fit: BoxFit.cover,
          ),
          // Image.network(
          //   produto.imageUrl,

          // ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          //consumer vai alterar esse objeto especifico

          leading: Consumer<Produtos>(
            builder: (ctx, produtos, _) => IconButton(
              icon: Icon(
                  produto.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                produto.validarFavorite(auth.token, auth.userId);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            produto.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Produto adicionado com sucesso!'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                    label: 'DESFAZER',
                    onPressed: () {
                      carrinho.removerCarrinho(produto.id);
                    }),
              ));
              carrinho.addItem(produto);
              print(carrinho.itemsCount);
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
