class Livros {
  final int id;
  final String nome;
  final String? editora;
  final String? author;
  final int? ano;

  const Livros(
      {required this.id,
      required this.nome,
      this.editora,
      this.author,
      this.ano});

  factory Livros.fromJson(Map<String, dynamic> json) {
    return Livros(
      id: json['id'] as int,
      nome: json['nome'] as String,
      editora: json['editora'] as String,
      author: json['author'] as String,
      ano: json['ano'] as int,
    );
  }
}
