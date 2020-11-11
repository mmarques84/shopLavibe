import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppLavibe/models/carrinho.dart';
import 'package:shoppLavibe/models/produtos.dart';

import 'package:shoppLavibe/providers/auth.dart';
import 'package:shoppLavibe/providers/pedidos.dart';
import 'package:shoppLavibe/providers/produtos_providers.dart';

import 'package:shoppLavibe/utils/app_routers.dart';
import 'package:shoppLavibe/utils/custom_route.dart';
import 'package:shoppLavibe/views/auth_home_tela.dart';

import 'package:shoppLavibe/views/carrinho_tela.dart';
import 'package:shoppLavibe/views/auth_screen.dart';
import 'package:shoppLavibe/views/pedido_tela.dart';
import 'package:shoppLavibe/views/produto_detalhes.dart';
import 'package:shoppLavibe/views/produto_form_tela.dart';
import 'package:shoppLavibe/views/produtos_crud.dart';
import 'package:shoppLavibe/views/produtos_tela.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProdutosProviders>(
          create: (_) => new ProdutosProviders(),
          update: (ctx, auth, previousProdutos) => new ProdutosProviders(
              auth.token, auth.userId, previousProdutos.items),
        ),
        ChangeNotifierProvider(
          create: (_) => new Carrinho(),
        ),
        ChangeNotifierProxyProvider<Auth, Pedidos>(
          create: (_) => new Pedidos(),
          update: (ctx, auth, previousProdutos) =>
              new Pedidos(auth.token, auth.userId, previousProdutos.items),
        ),
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.deepOrange,
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomPageTransitionsBuilder(),
              TargetPlatform.iOS: CustomPageTransitionsBuilder(),
            },
          ),
        ),
        //home: ProdutoTela(),
        routes: {
          AppRoutes.Auth_HOME: (ctx) => AuthOrHomeTela(),
          AppRoutes.ProdutosDetalhes: (ctx) => ProdutoDetalhes(),
          AppRoutes.CarrinhoTela: (ctx) => CarrinhoTela(),
          AppRoutes.Home: (ctx) => ProdutoTela(),
          AppRoutes.PedidoTela: (ctx) => PedidoTela(),
          AppRoutes.ProdutosCrud: (ctx) => ProdutosCrud(),
          AppRoutes.ProdutosForm: (ctx) => ProdutoFormTela(),
        },
      ),
    );
  }
}
