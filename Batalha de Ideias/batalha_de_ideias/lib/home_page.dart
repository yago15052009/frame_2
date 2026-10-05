import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final _db = FirebaseFirestore.instance;

  CollectionReference get _ideias => _db.collection('ideias');

  void _votar(String id, int votosAtuais) {
    _ideias.doc(id).update({'votos': votosAtuais + 1});
  }

  void _excluir(String id) {
    _ideias.doc(id).delete();
  }

  void _abrirFormulario(BuildContext context) {
    final titulo = TextEditingController();
    final descricao = TextEditingController();
    final autor = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nova Ideia'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titulo, decoration: const InputDecoration(labelText: 'Título')),
            TextField(controller: descricao, decoration: const InputDecoration(labelText: 'Descrição')),
            TextField(controller: autor, decoration: const InputDecoration(labelText: 'Autor')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              if (titulo.text.trim().isEmpty || autor.text.trim().isEmpty) return;
              _ideias.add({
                'titulo': titulo.text.trim(),
                'descricao': descricao.text.trim(),
                'autor': autor.text.trim(),
                'votos': 0,
              });
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💡 Batalha de Ideias'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ideias.orderBy('votos', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhuma ideia cadastrada ainda.'));
          }

          final docs = snapshot.data!.docs;
          final maisVotada = docs.first;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                final data = maisVotada.data() as Map<String, dynamic>;
                return Card(
                  color: Colors.amber.shade100,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🏆 IDEIA MAIS VOTADA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(data['titulo'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('❤️ ${data['votos']} votos', style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                );
              }

              final doc = docs[index - 1];
              final data = doc.data() as Map<String, dynamic>;
              final votos = (data['votos'] as num).toInt();

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(data['titulo'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _excluir(doc.id),
                          ),
                        ],
                      ),
                      Text(data['autor'] ?? '', style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Text(data['descricao'] ?? ''),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('❤️ $votos votos', style: const TextStyle(fontSize: 14)),
                          const Spacer(),
                          FilledButton(
                            onPressed: () => _votar(doc.id, votos),
                            child: const Text('VOTAR'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(context),
        icon: const Icon(Icons.add),
        label: const Text('Nova Ideia'),
      ),
    );
  }
}
