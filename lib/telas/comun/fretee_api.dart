class FreteeApi {
  static String url = "http://192.168.0.243:8080/api";
  static String loginUrn = "/autenticacao/login";
  static String cadastroUsuarioUrn = "/usuario";
  static String accessToken = "";
  static String refreshToken = "";

  static Uri getLoginUri() {
    return Uri.parse(url + loginUrn);
  }

  static Uri getUriCadastrarUsuario() {
    return Uri.parse(url + cadastroUsuarioUrn);
  }
}
