import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fretee_mobile/telas/comun/fretee_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CadastroUsuario extends StatefulWidget {
  const CadastroUsuario({Key? key}) : super(key: key);

  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  File? _image;
  final _nomeCompletoTextControlle = TextEditingController();
  final _telefoneTextControlle = TextEditingController();
  final _nomeUsuarioTextControlle = TextEditingController();
  final _senhaTextControlle = TextEditingController();
  String? _erroMsg;
  String _msgFotoNaoSelecionada = "";
  Color _borberColorImagePicker = Colors.grey.shade400;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastra-se"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _ConstruirSeletorImagem(),
            _ConstruirformularioDeCadastro()
          ],
        ),
      ),
    );
  }

  Widget _ConstruirSeletorImagem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: _borberColorImagePicker),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: _image != null
                      ? Image.file(
                          _image!,
                          width: 100,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : const Icon(
                          Icons.image,
                          size: 80,
                        ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 10),
                width: 250,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: selecionarImagemDaGaleria,
                        child: const Text("Selecionar Imagem"),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            // elevation: 15.0,
                            minimumSize: const Size(100, 10))),
                    const Text(
                      "Escolha uma imagem que seu rosto esteja visivel.",
                      style: TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10),
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            _msgFotoNaoSelecionada,
            textAlign: TextAlign.left,
            style: TextStyle(color: _borberColorImagePicker),
          ),
        )
      ],
    );
  }

  Future selecionarImagemDaGaleria() async {
    try {
      final imagem = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagem == null) return;
      final imageFile = File(imagem.path);
      setState(() {
        this._image = imageFile;
        _msgFotoNaoSelecionada = "";
        _borberColorImagePicker = Colors.grey.shade400;
      });
    } on PlatformException catch (e) {
      print("Não foi possivel selecionar a imagem");
    }
  }

  Widget _ConstruirformularioDeCadastro() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ConstruirInputDoFormulatio("Nome Completo",
                _nomeCompletoTextControlle, TextInputType.text, false, false),
            _ConstruirInputDoFormulatio("Telefone", _telefoneTextControlle,
                TextInputType.number, false, false),
            _ConstruirInputDoFormulatio("Nome de Usuario",
                _nomeUsuarioTextControlle, TextInputType.text, false, true),
            _ConstruirInputDoFormulatio(
                "Senha", _senhaTextControlle, TextInputType.text, true, false),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: TextButton(
                  onPressed: _cadastrarUsuario,
                  child: const Text(
                    "Cadastrar",
                    style: TextStyle(fontSize: 20),
                  ),
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      // elevation: 15.0,
                      minimumSize: const Size(100, 50))),
            )
          ],
        ),
      ),
    );
  }

  Widget _ConstruirInputDoFormulatio(
      String label,
      TextEditingController controller,
      TextInputType keyboardType,
      bool obscureText,
      bool userName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                  color: Colors.black45, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              errorText: userName ? _erroMsg : null),
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return "Insira o/a ${label}";
            }
          },
          obscureText: obscureText,
          enableSuggestions: !obscureText,
          autocorrect: !obscureText),
    );
  }

  void _cadastrarUsuario() async {
    if (!validateImageAndForm()) return;

    var request =
        http.MultipartRequest("POST", FreteeApi.getUriCadastrarUsuario());

    request.fields["nome"] = _nomeCompletoTextControlle.text;
    request.fields["telefone"] = _telefoneTextControlle.text;
    request.fields["nomeAutenticacao"] = _nomeUsuarioTextControlle.text;
    request.fields["senha"] = _senhaTextControlle.text;

    var imageUsuario = await http.MultipartFile.fromPath("foto", _image!.path);

    request.files.add(imageUsuario);

    var response = await request.send();

    switch (response.statusCode) {
      case HttpStatus.badRequest:
        var error = response.headers["error"];
        setState(() {
          _erroMsg = error;
        });
        break;
    }
  }

  bool validateImageAndForm() {
    if (_image == null) {
      setState(() {
        _msgFotoNaoSelecionada = "Selecione uma foto";
      });
      _borberColorImagePicker = Colors.red;
      return false;
    }

    var form = _formKey.currentState;
    if (!form!.validate()) return false;

    return true;
  }
}
