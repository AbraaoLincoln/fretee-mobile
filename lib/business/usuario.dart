import 'package:fretee_mobile/business/device_location.dart';

class Usuario {
  static Usuario logado = Usuario();
  late String nomeUsuario;
  bool ehPresetadorDeServico = false;
  late DeviceLocation location;
}
