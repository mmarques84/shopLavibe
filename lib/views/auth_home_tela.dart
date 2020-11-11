import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppLavibe/providers/auth.dart';
import 'package:shoppLavibe/views/produtos_tela.dart';

import 'auth_screen.dart';

class AuthOrHomeTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('Ocorreu um erro!'));
        } else {
          return auth.isAuth ? ProdutoTela() : AuthScreen();
        }
      },
    );
  }
}
