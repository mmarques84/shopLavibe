import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shoppLavibe/models/produtos.dart';
import 'package:shoppLavibe/providers/produtos_providers.dart';

class ProdutoFormTela extends StatefulWidget {
  @override
  _ProdutoFormTelaState createState() => _ProdutoFormTelaState();
}

class _ProdutoFormTelaState extends State<ProdutoFormTela> {
  final _priceFocusNode = FocusNode();
  final _descricaoFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;
  Produtos _produto;
  List<File> _listaImagens = List();
  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final product = ModalRoute.of(context).settings.arguments as Produtos;

      if (product != null) {
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = _formData['imageUrl'];
      } else {
        _formData['price'] = '';
      }
    }
  }

  void _updateImage() {
    if (isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  bool isValidImageUrl(String url) {
    bool startWithHttp = url.toLowerCase().startsWith('http://');
    bool startWithHttps = url.toLowerCase().startsWith('https://');
    bool startWith = url.toLowerCase().startsWith('file://');
    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');
    return (startWithHttp || startWithHttps || startWith) &&
        (endsWithPng || endsWithJpg || endsWithJpeg);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descricaoFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
  }

  Future<void> _saveForm() async {
    var isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }

    _form.currentState.save();

    final product = Produtos(
      id: _formData['id'],
      title: _formData['title'],
      price: _formData['price'],
      description: _formData['description'],
      imageUrl: _formData['imageUrl'],
      // fotos: _formData['fotos'],
    );

    setState(() {
      _isLoading = true;
    });

    final products = Provider.of<ProdutosProviders>(context, listen: false);

    try {
      if (_formData['id'] == null) {
        await products.addProduct(product);
      } else {
        await products.updateProduct(product);
      }
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Ocorreu um erro!'),
          content: Text('Ocorreu um erro pra salvar o produto!'),
          actions: <Widget>[
            FlatButton(
              child: Text('Fechar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    //Navigator.of(context).pop();
  }

  _selecionarImagemGaleria() async {
    File imagemSelecionada =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imagemSelecionada != null) {
      setState(() {
        _listaImagens.add(imagemSelecionada);
      });
    }
  }

  Future _uploadImagens() async {
    // FirebaseStorage storage = FirebaseStorage.instance;
    // StorageReference pastaRaiz = storage.ref();
    // print(storage);
    // for (var imagem in _listaImagens) {
    //   print(_listaImagens);
    //   String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    //   StorageReference arquivo =
    //       pastaRaiz.child("produto").child(_produto.id).child(nomeImagem);

    //   StorageUploadTask uploadTask = arquivo.putFile(imagem);
    //   StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    //   String url = await taskSnapshot.ref.getDownloadURL();
    //   _produto.fotos.add(url);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario Produto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    // FormField<List>(
                    //   initialValue: null,
                    //   validator: (imagens) {
                    //     if (imagens.length == 0) {
                    //       return "Necessário selecionar uma imagem !";
                    //     }
                    //     return null;
                    //   },
                    //   //carregar a imagem:
                    //   builder: (state) {
                    //     return Column(
                    //       children: <Widget>[
                    //         Container(
                    //           height: 100,
                    //           child: ListView.builder(
                    //               scrollDirection: Axis.horizontal,
                    //               itemCount: _listaImagens.length + 1, //3
                    //               itemBuilder: (context, indice) {
                    //                 if (indice == _listaImagens.length) {
                    //                   return Padding(
                    //                     padding:
                    //                         EdgeInsets.symmetric(horizontal: 8),
                    //                     child: GestureDetector(
                    //                       onTap: () {
                    //                         _selecionarImagemGaleria();
                    //                       },
                    //                       child: CircleAvatar(
                    //                         backgroundColor: Colors.grey[400],
                    //                         radius: 50,
                    //                         child: Column(
                    //                           mainAxisAlignment:
                    //                               MainAxisAlignment.center,
                    //                           children: <Widget>[
                    //                             Icon(
                    //                               Icons.add_a_photo,
                    //                               size: 40,
                    //                               color: Colors.grey[100],
                    //                             ),
                    //                             Text(
                    //                               "Adicionar",
                    //                               style: TextStyle(
                    //                                   color: Colors.grey[100]),
                    //                             )
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   );
                    //                 }

                    //                 if (_listaImagens.length > 0) {
                    //                   return Padding(
                    //                     padding:
                    //                         EdgeInsets.symmetric(horizontal: 8),
                    //                     child: GestureDetector(
                    //                       onTap: () {
                    //                         showDialog(
                    //                             context: context,
                    //                             builder: (context) => Dialog(
                    //                                   child: Column(
                    //                                     mainAxisSize:
                    //                                         MainAxisSize.min,
                    //                                     children: <Widget>[
                    //                                       Image.file(
                    //                                           _listaImagens[
                    //                                               indice]),
                    //                                       FlatButton(
                    //                                         child:
                    //                                             Text("Excluir"),
                    //                                         textColor:
                    //                                             Colors.red,
                    //                                         onPressed: () {
                    //                                           setState(() {
                    //                                             _listaImagens
                    //                                                 .removeAt(
                    //                                                     indice);
                    //                                             Navigator.of(
                    //                                                     context)
                    //                                                 .pop();
                    //                                           });
                    //                                         },
                    //                                       )
                    //                                     ],
                    //                                   ),
                    //                                 ));
                    //                       },
                    //                       child: CircleAvatar(
                    //                         radius: 50,
                    //                         backgroundImage: FileImage(
                    //                             _listaImagens[indice]),
                    //                         child: Container(
                    //                           color: Color.fromRGBO(
                    //                               255, 255, 255, 0.4),
                    //                           alignment: Alignment.center,
                    //                           child: Icon(
                    //                             Icons.delete,
                    //                             color: Colors.red,
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   );
                    //                 }
                    //                 return Container();
                    //               }),
                    //         ),
                    //         //mostrar o erro
                    //         if (state.hasError)
                    //           Container(
                    //             child: Text(
                    //               "${state.errorText}",
                    //               style: TextStyle(
                    //                   color: Colors.red, fontSize: 14),
                    //             ),
                    //           )
                    //       ],
                    //     );
                    //   },
                    // ),
                    TextFormField(
                      initialValue: _formData['title'],
                      decoration: InputDecoration(labelText: 'Título'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) => _formData['title'] = value,
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        bool isInvalid = value.trim().length < 3;

                        if (isEmpty || isInvalid) {
                          return 'Informe um Título válido com no mínimo 3 caracteres!';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price'].toString(),
                      decoration: InputDecoration(labelText: 'Preço'),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descricaoFocusNode);
                      },
                      onSaved: (value) =>
                          _formData['price'] = double.parse(value),
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        var newPrice = double.tryParse(value);
                        bool isInvalid = newPrice == null || newPrice <= 0;

                        if (isEmpty || isInvalid) {
                          return 'Informe um Preço válido!';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description'],
                      decoration: InputDecoration(labelText: 'Descrição'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descricaoFocusNode,
                      onSaved: (value) => _formData['description'] = value,
                      validator: (value) {
                        bool isEmpty = value.trim().isEmpty;
                        bool isInvalid = value.trim().length < 10;

                        if (isEmpty || isInvalid) {
                          return 'Informe uma Descrição válida com no mínimo 10 caracteres!';
                        }

                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            decoration:
                                InputDecoration(labelText: 'URL da Imagem'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) => _formData['imageUrl'] = value,
                            validator: (value) {
                              bool isEmpty = value.trim().isEmpty;
                              bool isInvalid = !isValidImageUrl(value);

                              if (isEmpty || isInvalid) {
                                return 'Informe uma URL válida!';
                              }

                              return null;
                            },
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? Text('Informe a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
