import '../models/usuario.dart';
import 'database_service.dart';

class UsuarioService {
  Future<String?> cadastrar(Usuario usuario) async {
    final db = await DatabaseService.banco;

    final existe = await db.query('usuarios', where: 'email = ?', whereArgs: [usuario.email]);
    if (existe.isNotEmpty) {
      print('SELECT → E-mail já existe: ${usuario.email}');
      return 'E-mail já cadastrado.';
    }

    await db.insert('usuarios', usuario.toMap());
    print('INSERT → Usuário cadastrado: ${usuario.nome}');
    return null;
  }

  Future<Usuario?> login(String email, String senha) async {
    final db = await DatabaseService.banco;

    print('SELECT → Procurando usuário: $email');
    final result = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
    );

    if (result.isNotEmpty) {
      final usuario = Usuario.fromMap(result.first);
      print('SELECT → Usuário encontrado: ${usuario.nome}');
      return usuario;
    }

    print('SELECT → Usuário não encontrado');
    return null;
  }
}
