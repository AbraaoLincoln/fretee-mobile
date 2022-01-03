class FreteeApi {
  static String url = "http://192.168.0.243:8080/api";
  static String loginUrn = "/autenticacao/login";
  static String cadastroUsuarioUrn = "/usuario";
  static String prestadoresServicoProximoUrn = "/prestador-servico/proximos";
  static String prestadoresServicoFotoVeiculoUrn =
      "/prestador-servico/veiculo/foto";
  static String accessToken = "";
  static String refreshToken = "";
  static String bearer = "Bearer ";

  static Uri getLoginUri() {
    return Uri.parse(url + loginUrn);
  }

  static Uri getUriCadastrarUsuario() {
    return Uri.parse(url + cadastroUsuarioUrn);
  }

  static Uri getUriPrestadoresServicoProximo() {
    return Uri.parse(url + prestadoresServicoProximoUrn);
  }

  static String getaccessToken() {
    return bearer + accessToken;
  }

  static String getUriPrestadoresServicoFotoVeiculo(
      String nomeUsuarioPrestadorServico) {
    return url +
        "/prestador-servico/" +
        nomeUsuarioPrestadorServico +
        "/veiculo/foto";
  }
}
