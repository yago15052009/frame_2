import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/produto_provider.dart';
import '../models/produto.dart';

class EstoquePage extends StatefulWidget {
  const EstoquePage({super.key});

  @override
  State<EstoquePage> createState() => _EstoquePageState();
}

class _EstoquePageState extends State<EstoquePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProdutoProvider>().carregar();
    });
  }

  @override
  Widget build(BuildContext context) {
    final produtos = context.watch<ProdutoProvider>().produtos;
    return Scaffold(
      appBar: AppBar(title: const Text('ESTOQUE'), centerTitle: true),
      body: produtos.isEmpty
          ? const Center(child: Text('Nenhum produto cadastrado.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: produtos.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final p = produtos[index];
                return _ProdutoCard(produto: p);
              },
            ),
    );
  }
}

class _ProdutoCard extends StatelessWidget {
  final Produto produto;
  const _ProdutoCard({required this.produto});

  @override
  Widget build(BuildContext context) {
    final baixo = produto.quantidade <= 3;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(produto.nome, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(produto.categoria),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => context.read<ProdutoProvider>().alterarQuantidade(produto, -1),
            ),
            Text('Quantidade: ${produto.quantidade}'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.read<ProdutoProvider>().alterarQuantidade(produto, 1),
            ),
          ],
        ),
        Text('R\$ ${produto.preco.toStringAsFixed(2)}'),
        if (baixo)
          const Text('ESTOQUE BAIXO', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () => context.read<ProdutoProvider>().excluir(produto),
          child: const Text('EXCLUIR', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
