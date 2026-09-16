import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';

class UsuarioProvider extends ChangeNotifier {
  final _service = UsuarioService();
  Usuario? usuarioLogado;
  String? erro;

  Future<bool> login(String email, String senha) async {
    erro = null;
    usuarioLogado = await _service.login(email, senha);
    if (usuarioLogado == null) erro = 'E-mail ou senha incorretos.';
    notifyListeners();
    return usuarioLogado != null;
  }

  Future<String?> cadastrar(String nome, String email, String senha) async {
    final msg = await _service.cadastrar(Usuario(nome: nome, email: email, senha: senha));
    return msg;
  }

  void logout() {
    usuarioLogado = null;
    notifyListeners();
  }
}
