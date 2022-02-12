import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fretee_mobile/ui/comun/modo_formulario.dart';
import 'package:fretee_mobile/ui/home/fragmentos/perfil_fragmento.dart';
import 'package:fretee_mobile/ui/home/home.dart';
import 'package:fretee_mobile/utils/fretee_api.dart';
import 'package:fretee_mobile/ui/login/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CadastroUsuario extends StatefulWidget {
  final ModoFormulario modoFormulario;
  final String? initNomeCompleto;
  final String? initTelefone;
  final String? initNomeUsuario;
  final Image? initImage;
  final int? usuarioId;
  const CadastroUsuario(
      {Key? key,
      required this.modoFormulario,
      this.initImage,
      this.initNomeCompleto,
      this.initTelefone,
      this.initNomeUsuario,
      this.usuarioId})
      : super(key: key);

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late MyDialog _myDialog;
  late String _buttonLabel;

  @override
  void initState() {
    super.initState();

    _nomeCompletoTextControlle.text = widget.initNomeCompleto ?? "";
    _telefoneTextControlle.text = widget.initTelefone ?? "";
    _nomeUsuarioTextControlle.text = widget.initNomeUsuario ?? "";

    if (widget.modoFormulario == ModoFormulario.cadastro) {
      _buttonLabel = "Cadastrar";
    }

    if (widget.modoFormulario == ModoFormulario.edicao) {
      _buttonLabel = "Salvar";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuario"),
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
        this._image = imageFile;
        _msgFotoNaoSelecionada = "";
        _borberColorImagePicker = Colors.grey.shade400;
      });
    } on PlatformException catch (e) {
      print("Não foi possivel selecionar a imagem");
    }
  }

  Widget _ConstruirformularioDeCadastro() {
    List<Widget> camposFormulario = [
      _ConstruirInputDoFormulatio("Nome Completo", _nomeCompletoTextControlle,
          TextInputType.text, false, false),
      _ConstruirInputDoFormulatio("Telefone", _telefoneTextControlle,
          TextInputType.number, false, false),
      _ConstruirInputDoFormulatio("Nome de Usuario", _nomeUsuarioTextControlle,
          TextInputType.text, false, true),
    ];

    if (widget.modoFormulario == ModoFormulario.cadastro) {
      camposFormulario.add(_ConstruirInputDoFormulatio(
          "Senha", _senhaTextControlle, TextInputType.text, true, false));
    }

    camposFormulario.add(_construirBotoes());

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: camposFormulario,
      ),
    );
  }

  Widget _construirBotoes() {
    if (widget.modoFormulario == ModoFormulario.cadastro) {
      return Container(
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
                minimumSize: const Size(100, 50))),
      );
    } else if (widget.modoFormulario == ModoFormulario.edicao) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: TextButton(
              onPressed: _atualizarInfoUsuario,
              child: const Text(
                "Salvar",
                style: TextStyle(fontSize: 20),
              ),
              style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(100, 50))),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: TextButton(
              onPressed: () {},
              child: const Text(
                "Alterar senha",
                style: TextStyle(fontSize: 20),
              ),
              style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size(100, 50))),
        )
      ]);
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: TextButton(
            onPressed: () {},
            child: const Text(
              "Sem ação",
              style: TextStyle(fontSize: 20),
            ),
            style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                minimumSize: const Size(100, 50))),
      );
    }
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
              return "Insira o/a $label";
            }
          },
          obscureText: obscureText,
          enableSuggestions: !obscureText,
          autocorrect: !obscureText),
    );
  }

  void _cadastrarUsuario() {
    if (!validateImageAndForm()) return;
    _showCadastrandoDialog();
    _fazerRequestComBaseNoModoDoFormulario();
  }

  void _atualizarInfoUsuario() {
    if (!_validateForm()) return;
    _showCadastrandoDialog();
    _fazerRequestComBaseNoModoDoFormulario();
  }

  void _fazerRequestComBaseNoModoDoFormulario() async {
    http.MultipartRequest request;
    if (widget.modoFormulario == ModoFormulario.cadastro) {
      request =
          http.MultipartRequest("POST", FreteeApi.getUriCadastrarUsuario());
      request.fields["senha"] = _senhaTextControlle.text;
    } else {
      request = http.MultipartRequest(
          "PUT", FreteeApi.getUriAtualizarUsuarioInfo(widget.usuarioId!));
      request.headers[HttpHeaders.authorizationHeader] =
          FreteeApi.getAccessToken();
    }

    request.fields["nomeCompleto"] = _nomeCompletoTextControlle.text;
    request.fields["telefone"] = _telefoneTextControlle.text;
    request.fields["nomeAutenticacao"] = _nomeUsuarioTextControlle.text;

    if (_image != null) {
      var imageUsuario =
          await http.MultipartFile.fromPath("foto", _image!.path);
      request.files.add(imageUsuario);
    }

    var response = await request.send();

    switch (response.statusCode) {
      case HttpStatus.ok:
        log("Informacoes do usuario atualizadas com sucesso");
        _myDialog.showRes(response.statusCode);
        break;
      case HttpStatus.created:
        log("Usuario cadastro com suscesso");
        _myDialog.showRes(response.statusCode);
        break;
      case HttpStatus.badRequest:
        log("Opa badrequest");
        Navigator.pop(context, 'OK');
        var error = response.headers["error"];
        setState(() {
          _erroMsg = error;
        });
        break;
      default:
        log("Nao foi possivel realizar a operacao");
        _myDialog.showRes(response.statusCode);
    }
  }

  bool validateImageAndForm() {
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
          _alertContent = Text(widget.msgSuccess);
          _alertActions.add(TextButton(
            onPressed: _loadPerfil,
            child: const Text('OK'),
          ));
          break;
        case HttpStatus.created:
          _alertContent = Text(widget.msgSuccess);
          _alertActions.add(TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Login(),
                  ),
                  (route) => false);
            },
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
