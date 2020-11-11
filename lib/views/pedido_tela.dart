import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppLavibe/providers/pedidos.dart';
import 'package:shoppLavibe/widgets/app_drawer.dart';
import 'package:shoppLavibe/widgets/pedido_widget.dart';

class PedidoTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Pedidos>(context, listen: false).loadPedidos(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(child: Text('Ocorreu um erro!'));
          } else {
            return Consumer<Pedidos>(
              builder: (ctx, orders, child) {
                return ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, i) => PedidoWidget(orders.items[i]),
                );
              },
            );
          }
        },
      ),
      //  _isLoading
      //     ? Center(child: CircularProgressIndicator())
      //     : ListView.builder(
      //         itemCount: pedidos.itemsCount,
      //         itemBuilder: (ctx, i) => PedidoWidget(pedidos.items[i]),
      //       ),
    );
  }
}
