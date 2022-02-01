class PlaceholderUtils {
  static Map<String, dynamic> getUsuario() {
    Map<String, dynamic> placeholder = {};

    placeholder["nomeUsuario"] = "Nome Sobrenome";
    placeholder["reputacaoUsuario"] = 4.5;
    placeholder["distancia"] = 3.1;

    return placeholder;
  }

  static Map<String, dynamic> getFrete() {
    Map<String, dynamic> placeholder = {};

    placeholder["origem"] = "redinha";
    placeholder["destino"] = "lagoa";
    placeholder["data"] = "2021-02-20";
    placeholder["hora"] = "10:00";
    placeholder["descricaoCarga"] = "teste testando";

    return placeholder;
  }
}
