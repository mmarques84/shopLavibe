import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppLavibe/models/carrinho.dart';
import 'package:shoppLavibe/providers/pedidos.dart';
import 'package:shoppLavibe/widgets/carrinho_item_widget.dart';

class CarrinhoTela extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    final Carrinho cart = Provider.of(context);
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(25),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      'R\$${cart.totalAmount}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  Botaocompra(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemsCount,
              itemBuilder: (ctx, i) => CarrinhoItemWidget(cartItems[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class Botaocompra extends StatefulWidget {
  const Botaocompra({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Carrinho cart;

  @override
  _BotaocompraState createState() => _BotaocompraState();
}

class _BotaocompraState extends State<Botaocompra> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('COMPRAR'),
      textColor: Theme.of(context).primaryColor,
      onPressed: widget.cart.totalAmount == 0
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });

              await Provider.of<Pedidos>(context, listen: false)
                  .addPedido(widget.cart);

              setState(() {
                _isLoading = false;
              });

              widget.cart.clear();
            },
    );
  }
}
