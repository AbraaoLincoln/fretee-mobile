import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fretee_mobile/business/device_location.dart';
import 'package:fretee_mobile/ui/comun/modo_formulario.dart';
import 'package:fretee_mobile/utils/fretee_api.dart';
import 'package:fretee_mobile/business/usuario.dart';
import 'package:fretee_mobile/ui/home/fragmentos/perfil_fragmento.dart';
import 'package:fretee_mobile/ui/home/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CadastroPrestadorServico extends StatefulWidget {
  final String? initValueLargura;
  final String? initValueAltura;
  final String? initValueComprimento;
  final String? initValuePlaca;
  final Image? initImage;
  final int? veiculoId;
  final ModoFormulario modoFormulario;
  const CadastroPrestadorServico(
      {Key? key,
      this.initValueLargura,
      this.initValueAltura,
      this.initValueComprimento,
      this.initImage,
      required this.modoFormulario,
      this.veiculoId,
      this.initValuePlaca})
      : super(key: key);

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
  late String _buttonLabel;
  late String _msg;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late MyDialog _myDialog;

  @override
  void initState() {
    super.initState();

    _larguraTextControlle.text = widget.initValueLargura ?? "";
    _alturaTextControlle.text = widget.initValueAltura ?? "";
    _comprimentoTextControlle.text = widget.initValueComprimento ?? "";
    _placaTextControlle.text = widget.initValuePlaca ?? "";

    if (widget.modoFormulario == ModoFormulario.cadastro) {
      _msg =
          "Para se cadastrar como prestador de servi??o precisamos das informa????es do seu veiculo.";
      _buttonLabel = "Cadastrar";
    }

    if (widget.modoFormulario == ModoFormulario.edicao) {
      _msg = "Abaixo voc?? pode editar as informa????es do seu veiculo";
      _buttonLabel = "Salvar Edi????o";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prestador Servi??o"),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                _msg,
                style: const TextStyle(fontSize: 17),
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
                  child: _getRightImage(),
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

  Widget _getRightImage() {
    if (_image != null) {
      return Image.file(
        _image!,
        width: 100,
        height: 80,
        fit: BoxFit.cover,
      );
    }

    if (widget.initImage != null) return widget.initImage!;

    return const Icon(
      Icons.image,
      size: 80,
    );
  }

  Future selecionarImagemDaGaleria() async {
    try {
      final imagem = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imagem == null) return;
      final imageFile = File(imagem.path);
      setState(() {
        _image = imageFile;
        _msgFotoNaoSelecionada = "";
        _borberColorImagePicker = Colors.grey.shade400;
      });
    } on PlatformException catch (e) {
      print("N??o foi possivel selecionar a imagem");
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
                      if (widget.modoFormulario == ModoFormulario.cadastro) {
                        bool validateSuccessful = _validateImageAndForm();
                        if (validateSuccessful) {
                          _cadastrarComoPrestadorServico();
                        }
                      }

                      if (widget.modoFormulario == ModoFormulario.edicao) {
                        bool validateSuccessful = _validateForm();
                        if (validateSuccessful) {
                          _cadastrarComoPrestadorServico();
                        }
                      }
                    },
                    child: Text(
                      _buttonLabel,
                      style: const TextStyle(fontSize: 20),
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
            if (value!.isEmpty) return "Insira o/a $label";
          }),
    );
  }

  Future<void> _cadastrarComoPrestadorServico() async {
    _showCadastrandoDialog();
    // await DeviceLocation.getLocation();
    log("Cadastrando usuario como prestador de servico");
    log("username ${Usuario.logado.nomeUsuario}");

    http.MultipartRequest request;
    if (widget.modoFormulario == ModoFormulario.cadastro) {
      request = http.MultipartRequest(
        "POST",
        FreteeApi.getUriCadastrarPrestadorServico(),
      );
    } else {
      request = http.MultipartRequest(
          "PUT", FreteeApi.getUriAtualizarVeiculoInfo(widget.veiculoId!));
    }

    request.headers[HttpHeaders.authorizationHeader] =
        FreteeApi.getAccessToken();

    request.fields["largura"] = _larguraTextControlle.text;
    request.fields["comprimento"] = _comprimentoTextControlle.text;
    request.fields["altura"] = _alturaTextControlle.text;
    request.fields["placa"] = _placaTextControlle.text;

    if (_image != null) {
      var imageVeiculo =
          await http.MultipartFile.fromPath("fotoVeiculo", _image!.path);
      request.files.add(imageVeiculo);
    }

    var response = await request.send();

    switch (response.statusCode) {
      case HttpStatus.ok:
        log("Informacoes do veiculo atualizado com sucesso");
        _myDialog.showRes(response.statusCode);
        break;
      case HttpStatus.created:
        log("Cadastro de prestador de servico realizado com suscesso");
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
    return _validateForm() && _validateImage();
  }

  bool _validateForm() {
    var form = _formKey.currentState;
    if (!form!.validate()) return false;

    return true;
  }

  bool _validateImage() {
    if (_image == null) {
      setState(() {
        _msgFotoNaoSelecionada = "Selecione uma foto do seu veiculo";
      });
      _borberColorImagePicker = Colors.red;
      return false;
    }

    return true;
  }

  void _showCadastrandoDialog() {
    if (widget.modoFormulario == ModoFormulario.cadastro) {
      _myDialog = const MyDialog(
        msgSuccess: "Cadastro realizado com suscesso",
      );
    } else {
      _myDialog = const MyDialog(
        msgSuccess: "Dados atualizado com suscesso",
      );
    }
    showDialog(context: context, builder: (context) => _myDialog);
  }
}

class MyDialog extends StatefulWidget {
  final String msgSuccess;
  const MyDialog({Key? key, required this.msgSuccess}) : super(key: key);

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
      title: const Text("Processando"),
      content: _alertContent,
      actions: _alertActions,
    );
  }

  void showRespose(int statusCode) {
    setState(() {
      switch (statusCode) {
        case HttpStatus.ok:
        case HttpStatus.created:
          _alertContent = Text(widget.msgSuccess);
          _alertActions.add(TextButton(
            onPressed: _loadPerfil,
            child: const Text('OK'),
          ));
          break;
        case HttpStatus.forbidden:
          log("forbidden");
          break;
        default:
          _alertContent = Text("Erro $statusCode");
          _alertActions.add(TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ));
      }
    });
  }

  void _loadPerfil() {
    //Navigator.pop(context);
    //Navigator.pop(context);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(
            activePage: PerfilFragmento(),
            activePageTitle: "Perfil",
          ),
        ),
        (route) => false);
  }
}
