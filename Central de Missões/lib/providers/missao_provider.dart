import 'package:flutter/material.dart';
import '../models/missao.dart';
import '../services/missao_service.dart';

class MissaoProvider extends ChangeNotifier {
  final _service = MissaoService();
  List<Missao> missoes = [];

  int get pontosConquistados => missoes
      .where((m) => m.concluida)
      .fold(0, (soma, m) => soma + m.pontos);

  Future<void> carregar() async {
    missoes = await _service.buscarTodas();
    notifyListeners();
  }

  Future<void> adicionar(String titulo, String dificuldade) async {
    final pontos = Missao.pontosParaDificuldade(dificuldade);
    final hoje = _dataHoje();
    final missao = Missao(
      titulo: titulo,
      dificuldade: dificuldade,
      pontos: pontos,
      data: hoje,
    );
    await _service.adicionar(missao);
    await carregar();
  }

  Future<void> concluir(Missao missao) async {
    await _service.atualizar(missao.id!, {'concluida': true});
    await carregar();
  }

  Future<void> excluir(String id) async {
    await _service.excluir(id);
    await carregar();
  }

  String _dataHoje() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }
}
