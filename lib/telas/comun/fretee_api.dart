class FreteeApi {
  static const String url = "http://192.168.0.246:8080/api";
  static const String loginUrn = "/autenticacao/login";
  static const String cadastroUsuarioUrn = "/usuario";
  static const String cadastroPrestadorServicoUrn = "/prestador-servico";
  static const String prestadoresServicoProximoUrn =
      "/prestador-servico/proximos";
  static const String prestadoresServicoFotoVeiculoUrn =
      "/prestador-servico/veiculo/foto";
  static const String usuarioFotoUrn = "/usuario/foto";
  static const String usuarioInfoUrn = "/usuario/info";
  static String accessToken = "";
  static String refreshToken = "";
  static const String bearer = "Bearer ";

  static void refreshAccessToken() {}

  static Uri getLoginUri() {
    return Uri.parse(url + loginUrn);
  }

  static Uri getUriCadastrarUsuario() {
    return Uri.parse(url + cadastroUsuarioUrn);
  }

  static Uri getUriCadastrarPrestadorServico() {
    return Uri.parse(url + cadastroPrestadorServicoUrn);
  }

  static Uri getUriPrestadoresServicoProximo(
      double? latitude, double? longitude) {
    return Uri.parse("$url$prestadoresServicoProximoUrn/$latitude/$longitude");
  }

  static String getAccessToken() {
    return bearer + accessToken;
  }

  static String getUriPrestadoresServicoFoto(
      String nomeUsuarioPrestadorServico) {
    return url + "/prestador-servico/" + nomeUsuarioPrestadorServico + "/foto";
  }

  static String getUriPrestadoresServicoFotoVeiculo(
      String nomeUsuarioPrestadorServico) {
    return url +
        "/prestador-servico/" +
        nomeUsuarioPrestadorServico +
        "/veiculo/foto";
  }

  static Uri getUriPrestadoresServicoVeiculoInfo(
      String nomeUsuarioPrestadorServico) {
    return Uri.parse(url +
        "/prestador-servico/" +
        nomeUsuarioPrestadorServico +
        "/veiculo/info");
  }

  static Uri getUriUsuarioInfo() {
    return Uri.parse(url + usuarioInfoUrn);
  }

  static String getUriUsuarioFoto() {
    return url + usuarioFotoUrn;
  }
}
