import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({Key? key}) : super(key: key);

  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastra-se"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [_SeletorImagem()],
        ),
      ),
    );
  }

  Widget _SeletorImagem() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: _image != null
                  ? Image.file(
                      _image!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.image,
                      size: 80,
                    ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10),
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: selecionarImagemDaGaleria,
                    child: Text("Selecionar Imagem"),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        // elevation: 15.0,
                        minimumSize: Size(100, 10))),
                Text(
                  "Escolha uma imagem que seu rosto esteja visivel.",
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future selecionarImagemDaGaleria() async {
    try {
      final imagem = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagem == null) return;
      final imageFile = File(imagem.path);
      setState(() {
        this._image = imageFile;
      });
    } on PlatformException catch (e) {
      print("Não foi possivel selecionar a imagem");
    }
  }
}
