import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CadastroPrestadorServico extends StatefulWidget {
  const CadastroPrestadorServico({Key? key}) : super(key: key);

  @override
  _CadastroPrestadorServicoState createState() =>
      _CadastroPrestadorServicoState();
}

class _CadastroPrestadorServicoState extends State<CadastroPrestadorServico> {
  File? _image;
  final _larguraTextControlle = TextEditingController();
  final _alturaTextControlle = TextEditingController();
  final _comprimentoTextControlle = TextEditingController();
  final _placaTextControlle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro Prestador Serviço"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Para se cadastrar como prestador de serviço precisamos das informações do seu veiculo.",
                style: TextStyle(fontSize: 17),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ]),
            ),
            _ConstruirSeletorImagem(),
            _ConstruirformularioDeCadastro()
          ],
        ),
      ),
    );
  }

  Widget _ConstruirSeletorImagem() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: _image != null
                  ? Image.file(
                      _image!,
                      width: 100,
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
                    child: Text("Selecionar Imagem do veiculo"),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        // elevation: 15.0,
                        minimumSize: Size(100, 10))),
                Text(
                  "Escolha uma imagem que mostre bem o seu veiculo.",
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

  Widget _ConstruirformularioDeCadastro() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ConstruirInputDoFormulatio(
              "Largura", _larguraTextControlle, TextInputType.number),
          _ConstruirInputDoFormulatio(
              "Altura", _alturaTextControlle, TextInputType.number),
          _ConstruirInputDoFormulatio(
              "Comprimento", _comprimentoTextControlle, TextInputType.number),
          _ConstruirInputDoFormulatio(
              "Placa", _placaTextControlle, TextInputType.text),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextButton(
                onPressed: () {},
                child: Text(
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
                    minimumSize: Size(100, 50))),
          )
        ],
      ),
    );
  }

  Widget _ConstruirInputDoFormulatio(String label,
      TextEditingController controller, TextInputType keyboardType) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: TextFormField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
              labelText: label,
              labelStyle:
                  TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade400),
              )),
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) return "Insira o/a ${label}";
          }),
    );
  }

  void _cadastrarComoPrestadorServico() async {
    var request = http.MultipartRequest(
        "POST", Uri.parse("http://192.168.0.243:8080/fretee/api/usuario/"));

    request.fields["nome"] = _larguraTextControlle.text;
    request.fields["telefone"] = _comprimentoTextControlle.text;
    request.fields["nomeAutenticacao"] = _alturaTextControlle.text;
    request.fields["senha"] = _comprimentoTextControlle.text;

    var imageUsuario = await http.MultipartFile.fromPath("foto", _image!.path);

    request.files.add(imageUsuario);

    var response = await request.send();
  }
}
