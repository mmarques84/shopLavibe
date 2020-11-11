import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppLavibe/models/carrinho.dart';

class CarrinhoItemWidget extends StatelessWidget {
  final CarrinhoItem carrinhoItem;
  CarrinhoItemWidget(this.carrinhoItem);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(carrinhoItem.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Tem certeza?'),
            content: Text("Vai remover o item?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Não')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Sim')),
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<Carrinho>(context, listen: false)
            .removeItem(carrinhoItem.productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text(' ${carrinhoItem.price}'),
                ),
              ),
            ),
            title: Text(carrinhoItem.title),
            subtitle: Text(
                'TOTAL: R\$ ${carrinhoItem.price * carrinhoItem.quantity}'),
            trailing: Text('${carrinhoItem.quantity}x'),
          ),
        ),
      ),
    );
  }
}
