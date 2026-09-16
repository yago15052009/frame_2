import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/usuario_provider.dart';
import 'cadastro_produto_page.dart';
import 'estoque_page.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final nome = context.watch<UsuarioProvider>().usuarioLogado?.nome ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('CONTROLE DE ESTOQUE'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Olá, $nome!', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EstoquePage())),
              child: const Text('VER PRODUTOS'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CadastroProdutoPage())),
              child: const Text('CADASTRAR PRODUTO'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<UsuarioProvider>().logout();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('SAIR', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
