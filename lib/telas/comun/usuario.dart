import 'package:fretee_mobile/telas/comun/device_location.dart';

class Usuario {
  static Usuario? usuarioLogado;
  late String nomeUsuario;
  bool ehPresetadorDeServico = false;
  late DeviceLocation location;

  Usuario(String nomeUsuario);
}
