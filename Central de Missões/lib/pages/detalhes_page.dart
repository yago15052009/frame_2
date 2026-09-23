import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/missao.dart';
import '../providers/missao_provider.dart';

class DetalhesPage extends StatelessWidget {
  final Missao missao;

  const DetalhesPage({super.key, required this.missao});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MissaoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Missão')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _linha('Título', missao.titulo),
            _linha('Dificuldade',
                '${Missao.estrelasParaDificuldade(missao.dificuldade)} ${missao.dificuldade}'),
            _linha('Pontos', '${missao.pontos}'),
            _linha('Status', missao.concluida ? 'Concluída ✅' : 'Pendente ⏳'),
            _linha('Data', missao.data),
            const SizedBox(height: 32),
            if (!missao.concluida)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await provider.concluir(missao);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Missão concluída! Você conquistou ${missao.pontos} pontos.'),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('CONCLUIR MISSÃO'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _linha(String label, String valor) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            children: [
              TextSpan(
                  text: '$label:\n',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: valor),
            ],
          ),
        ),
      );
}
