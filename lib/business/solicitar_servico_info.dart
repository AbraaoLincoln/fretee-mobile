class SolicitacaoServicoInfo {
  static SolicitacaoServicoInfo infoAtual = SolicitacaoServicoInfo.vazio();
  String origem = "";
  String destino = "";
  String dia = "";
  String hora = "";
  String descricaoCarga = "";
  bool precisaAjudandte = false;

  SolicitacaoServicoInfo.vazio();

  SolicitacaoServicoInfo.preencherTudo(String origem, String destino,
      String dia, String hora, String descicao, bool precisaAjudante);
}
