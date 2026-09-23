import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/missao.dart';
import '../providers/missao_provider.dart';
import 'detalhes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tituloController = TextEditingController();
  String _dificuldadeSelecionada = 'Fácil';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MissaoProvider>().carregar();
    });
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  void _mostrarDialogCadastro() {
    _tituloController.clear();
    _dificuldadeSelecionada = 'Fácil';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: const Text('Cadastrar Missão'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _dificuldadeSelecionada,
                decoration: const InputDecoration(labelText: 'Dificuldade'),
                items: ['Fácil', 'Médio', 'Difícil']
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (v) =>
                    setStateDialog(() => _dificuldadeSelecionada = v!),
              ),
              const SizedBox(height: 8),
              Text(
                'Pontos: ${Missao.pontosParaDificuldade(_dificuldadeSelecionada)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('CANCELAR'),
            ),
            ElevatedButton(
              onPressed: () async {
                final titulo = _tituloController.text.trim();
                if (titulo.isEmpty) return;
                Navigator.pop(ctx);
                await context
                    .read<MissaoProvider>()
                    .adicionar(titulo, _dificuldadeSelecionada);
              },
              child: const Text('CADASTRAR MISSÃO'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MissaoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de Missões'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.deepPurple.shade50,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'PONTOS CONQUISTADOS: ${provider.pontosConquistados}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
          Expanded(
            child: provider.missoes.isEmpty
                ? const Center(child: Text('Nenhuma missão cadastrada.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: provider.missoes.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, i) {
                      final missao = provider.missoes[i];
                      return _MissaoCard(missao: missao);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarDialogCadastro,
        icon: const Icon(Icons.add),
        label: const Text('Nova Missão'),
      ),
    );
  }
}

class _MissaoCard extends StatelessWidget {
  final Missao missao;

  const _MissaoCard({required this.missao});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MissaoProvider>();

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalhesPage(missao: missao),
        ),
      ).then((_) => provider.carregar()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              missao.titulo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
                'Dificuldade: ${Missao.estrelasParaDificuldade(missao.dificuldade)}'),
            Text('Pontos: ${missao.pontos}'),
            Text('Data: ${missao.data}'),
            Text(
              'Status: ${missao.concluida ? 'Concluída ✅' : 'Pendente ⏳'}',
              style: TextStyle(
                color: missao.concluida ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (!missao.concluida)
                  ElevatedButton(
                    onPressed: () async {
                      await provider.concluir(missao);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Missão concluída! Você conquistou ${missao.pontos} pontos.'),
                          ),
                        );
                      }
                    },
                    child: const Text('CONCLUIR'),
                  ),
                if (!missao.concluida) const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => provider.excluir(missao.id!),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red)),
                  child: const Text('EXCLUIR'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
