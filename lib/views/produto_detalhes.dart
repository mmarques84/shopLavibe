import 'package:flutter/material.dart';
import 'package:shoppLavibe/models/produtos.dart';

class ProdutoDetalhes extends StatelessWidget {
  //ProdutoDetalhes(this.produtos);

  @override
  Widget build(BuildContext context) {
    final Produtos produtos =
        ModalRoute.of(context).settings.arguments as Produtos;
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
              title: Text(produtos.title),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Hero(
                    tag: produtos.id,
                    child: Image.network(
                      produtos.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0, 0.8),
                        end: Alignment(0, 0),
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0.6),
                          Color.fromRGBO(0, 0, 0, 0),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              SizedBox(height: 10),
              Text(
                'R\$ ${produtos.price}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  produtos.description,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 1000),
            ],
          ),
        )
      ]),
    );
  }
}
