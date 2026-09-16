import '../models/produto.dart';
import 'database_service.dart';

class ProdutoService {
  Future<void> cadastrar(Produto produto) async {
    final db = await DatabaseService.banco;
    await db.insert('produtos', produto.toMap());
    print('INSERT → Produto cadastrado: ${produto.nome}');
    await mostrarProdutosNoTerminal();
  }

  Future<List<Produto>> listar() async {
    final db = await DatabaseService.banco;
    final result = await db.query('produtos');
    print('SELECT → Produtos encontrados:');
    for (final p in result) {
      print('{id: ${p['id']}, nome: ${p['nome']}, quantidade: ${p['quantidade']}}');
    }
    return result.map((e) => Produto.fromMap(e)).toList();
  }

  Future<void> atualizarQuantidade(Produto produto, int novaQuantidade) async {
    final db = await DatabaseService.banco;
    print('UPDATE → ${produto.nome}');
    print('Quantidade anterior: ${produto.quantidade}');
    print('Nova quantidade: $novaQuantidade');
    await db.update(
      'produtos',
      {'quantidade': novaQuantidade},
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  }

  Future<void> excluir(Produto produto) async {
    final db = await DatabaseService.banco;
    await db.delete('produtos', where: 'id = ?', whereArgs: [produto.id]);
    print('DELETE → Produto excluído: ${produto.nome}');
  }

  Future<void> mostrarProdutosNoTerminal() async {
    final db = await DatabaseService.banco;
    final produtos = await db.query('produtos');
    print('===== PRODUTOS NO BANCO =====');
    for (final produto in produtos) {
      print(produto);
    }
  }
}
