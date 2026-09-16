import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/produto_service.dart';

class ProdutoProvider extends ChangeNotifier {
  final _service = ProdutoService();
  List<Produto> produtos = [];

  Future<void> carregar() async {
    produtos = await _service.listar();
    notifyListeners();
  }

  Future<void> cadastrar(Produto produto) async {
    await _service.cadastrar(produto);
    await carregar();
  }

  Future<void> alterarQuantidade(Produto produto, int delta) async {
    final nova = produto.quantidade + delta;
    if (nova < 0) return;
    await _service.atualizarQuantidade(produto, nova);
    produto.quantidade = nova;
    notifyListeners();
  }

  Future<void> excluir(Produto produto) async {
    await _service.excluir(produto);
    produtos.remove(produto);
    notifyListeners();
  }
}
