class Missao {
  String? id;
  String titulo;
  String dificuldade;
  int pontos;
  bool concluida;
  String data;

  Missao({
    this.id,
    required this.titulo,
    required this.dificuldade,
    required this.pontos,
    this.concluida = false,
    required this.data,
  });

  Map<String, dynamic> toMap() => {
        'titulo': titulo,
        'dificuldade': dificuldade,
        'pontos': pontos,
        'concluida': concluida,
        'data': data,
      };

  factory Missao.fromMap(String id, Map<String, dynamic> map) => Missao(
        id: id,
        titulo: map['titulo'] ?? '',
        dificuldade: map['dificuldade'] ?? '',
        pontos: map['pontos'] ?? 0,
        concluida: map['concluida'] ?? false,
        data: map['data'] ?? '',
      );

  static int pontosParaDificuldade(String dificuldade) {
    switch (dificuldade) {
      case 'Médio':
        return 20;
      case 'Difícil':
        return 30;
      default:
        return 10;
    }
  }

  static String estrelasParaDificuldade(String dificuldade) {
    switch (dificuldade) {
      case 'Médio':
        return '⭐⭐';
      case 'Difícil':
        return '⭐⭐⭐';
      default:
        return '⭐';
    }
  }
}
