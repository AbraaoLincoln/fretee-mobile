class SolicitarServicoInfo {
  static SolicitarServicoInfo infoAtual = SolicitarServicoInfo.vazio();
  String origem = "";
  String destino = "";
  String dia = "";
  String hora = "";
  String descricaoCarga = "";
  bool precisaAjudandte = false;

  SolicitarServicoInfo.vazio();

  SolicitarServicoInfo.preencherTudo(String origem, String destino, String dia,
      String hora, String descicao, bool precisaAjudante);
}
