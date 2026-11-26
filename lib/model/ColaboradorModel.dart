class ColaboradorModel {
  final int id;
  final int perfilId;
  final String perfilNome;
  final String nomeCompleto;
  final String login;
  final String senhaHash;
  final String cargo;
  final String email;
  final String status;

  const ColaboradorModel({
    required this.id,
    required this.perfilId,
    required this.perfilNome,
    required this.nomeCompleto,
    required this.login,
    required this.senhaHash,
    required this.cargo,
    required this.email,
    required this.status,
  });

  factory ColaboradorModel.fromMap(Map<String, dynamic> map) {
    final perfilMap = map['perfis_acesso'] as Map<String, dynamic>?;
    return ColaboradorModel(
      id: map['id'] as int,
      perfilId: map['perfil_id'] as int,
      perfilNome: (perfilMap?['nome'] as String? ?? '').toLowerCase(),
      nomeCompleto: map['nome_completo'] as String? ?? '',
      login: (map['login'] as String? ?? '').toLowerCase(),
      senhaHash: map['senha_hash'] as String? ?? '',
      cargo: map['cargo'] as String? ?? '',
      email: map['email'] as String? ?? '',
      status: (map['status'] as String? ?? '').toLowerCase(),
    );
  }
}
