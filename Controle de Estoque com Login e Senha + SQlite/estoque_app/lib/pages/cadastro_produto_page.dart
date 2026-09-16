import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/produto.dart';
import '../providers/produto_provider.dart';

class CadastroProdutoPage extends StatefulWidget {
  const CadastroProdutoPage({super.key});

  @override
  State<CadastroProdutoPage> createState() => _CadastroProdutoPageState();
}

class _CadastroProdutoPageState extends State<CadastroProdutoPage> {
  final _nomeCtrl = TextEditingController();
  final _categoriaCtrl = TextEditingController();
  final _quantidadeCtrl = TextEditingController();
  final _precoCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _cadastrar() async {
    final nome = _nomeCtrl.text.trim();
    final categoria = _categoriaCtrl.text.trim();
    final quantidade = int.tryParse(_quantidadeCtrl.text.trim()) ?? 0;
    final preco = double.tryParse(_precoCtrl.text.trim()) ?? 0.0;

    if (nome.isEmpty || categoria.isEmpty) return;

    setState(() => _loading = true);
    await context.read<ProdutoProvider>().cadastrar(
      Produto(nome: nome, categoria: categoria, quantidade: quantidade, preco: preco),
    );
    setState(() => _loading = false);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CADASTRAR PRODUTO'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _nomeCtrl, decoration: const InputDecoration(labelText: 'Nome')),
            const SizedBox(height: 12),
            TextField(controller: _categoriaCtrl, decoration: const InputDecoration(labelText: 'Categoria')),
            const SizedBox(height: 12),
            TextField(controller: _quantidadeCtrl, decoration: const InputDecoration(labelText: 'Quantidade'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: _precoCtrl, decoration: const InputDecoration(labelText: 'Preço'), keyboardType: const TextInputType.numberWithOptions(decimal: true)),
            const SizedBox(height: 24),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _cadastrar, child: const Text('CADASTRAR PRODUTO')),
          ],
        ),
      ),
    );
  }
}
