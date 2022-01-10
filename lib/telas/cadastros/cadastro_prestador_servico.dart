import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fretee_mobile/telas/comun/device_location.dart';
import 'package:fretee_mobile/telas/comun/fretee_api.dart';
import 'package:fretee_mobile/telas/comun/usuario.dart';
import 'package:fretee_mobile/telas/home/home.dart';
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
  String _msgFotoNaoSelecionada = "";
  Color _borberColorImagePicker = Colors.grey.shade400;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late MyDialog _myDialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro Prestador Serviço"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
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
                      offset: const Offset(0, 1), // changes position of shadow
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
              border: Border.all(color: _borberColorImagePicker),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
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
                        child: const Text("Selecionar Imagem do veiculo"),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            // elevation: 15.0,
                            minimumSize: const Size(100, 10))),
                    const Text(
                      "Escolha uma imagem que mostre bem o seu veiculo.",
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
    return Form(
        key: _formKey,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ConstruirInputDoFormulatio(
                  "Largura", _larguraTextControlle, TextInputType.number),
              _ConstruirInputDoFormulatio(
                  "Altura", _alturaTextControlle, TextInputType.number),
              _ConstruirInputDoFormulatio("Comprimento",
                  _comprimentoTextControlle, TextInputType.number),
              _ConstruirInputDoFormulatio(
                  "Placa", _placaTextControlle, TextInputType.text),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: TextButton(
                    onPressed: () {
                      bool validateSuccessful = _validateImageAndForm();
                      if (validateSuccessful) _cadastrarComoPrestadorServico();
                    },
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
                        minimumSize: Size(100, 50))),
              )
            ],
          ),
        ));
  }

  Widget _ConstruirInputDoFormulatio(String label,
      TextEditingController controller, TextInputType keyboardType) {
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
              )),
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) return "Insira o/a ${label}";
          }),
    );
  }

  Future<void> _cadastrarComoPrestadorServico() async {
    _showCadastrandoDialog();
    await DeviceLocation.getLocation();
    log("Cadastrando usuario como prestador de servico");
    log("username ${Usuario.logado.nomeUsuario}");
    log("longitude ${Usuario.logado.location.longitude}");
    log("latitude ${Usuario.logado.location.latitude}");

    var request = http.MultipartRequest(
      "POST",
      FreteeApi.getUriCadastrarPrestadorServico(),
    );

    request.headers[HttpHeaders.authorizationHeader] =
        FreteeApi.getAccessToken();

    request.fields["largura"] = _larguraTextControlle.text;
    request.fields["comprimento"] = _comprimentoTextControlle.text;
    request.fields["altura"] = _alturaTextControlle.text;
    request.fields["placa"] = _placaTextControlle.text;
    request.fields["longitude"] = Usuario.logado.location.longitude.toString();
    request.fields["latitude"] = Usuario.logado.location.latitude.toString();

    var imageVeiculo =
        await http.MultipartFile.fromPath("fotoVeiculo", _image!.path);

    request.files.add(imageVeiculo);

    var response = await request.send();

    switch (response.statusCode) {
      case HttpStatus.created:
        log("Usuario cadastro com suscesso");
        _myDialog.showRes(response.statusCode);
        break;
      case HttpStatus.forbidden:
        log("forbidden");
        break;
      default:
        log(response.statusCode.toString());
        _myDialog.showRes(response.statusCode);
    }
  }

  bool _validateImageAndForm() {
    if (_image == null) {
      setState(() {
        _msgFotoNaoSelecionada = "Selecione uma foto do seu veiculo";
      });
      _borberColorImagePicker = Colors.red;
      return false;
    }

    var form = _formKey.currentState;
    if (!form!.validate()) return false;

    return true;
  }

  void _showCadastrandoDialog() {
    _myDialog = MyDialog();
    showDialog(context: context, builder: (context) => _myDialog);
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog({Key? key}) : super(key: key);

  void showRes(int statusCode) {
    _MyDialogState.currentDialog.showRespose(statusCode);
  }

  @override
  _MyDialogState createState() {
    _MyDialogState.currentDialog = _MyDialogState();
    return _MyDialogState.currentDialog;
  }
}

class _MyDialogState extends State<MyDialog> {
  static _MyDialogState currentDialog = _MyDialogState();
  Widget _alertContent = const SizedBox(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(
          semanticsLabel: 'Linear progress indicator',
        ),
      ));
  List<Widget> _alertActions = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Cadastrando"),
      content: _alertContent,
      actions: _alertActions,
    );
  }

  void showRespose(int statusCode) {
    setState(() {
      switch (statusCode) {
        case HttpStatus.created:
          _alertContent = const Text("Cadastro realizado com suscesso");
          _alertActions.add(TextButton(
            onPressed: _loadPerfil,
            child: const Text('OK'),
          ));
          break;
        case HttpStatus.forbidden:
          log("forbidden");
          break;
        default:
          _alertContent = Text("Erro ${statusCode}");
          _alertActions.add(TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ));
      }
    });
  }

  void _loadPerfil() {
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
