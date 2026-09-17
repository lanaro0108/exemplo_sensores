// Modelo de dados => representa um registro de ponto ou diário de campo

class PontoRegistro {
  final int? id;
  final String dataHora;
  final double latitude;
  final double longitude;
  final String observacao;
  final String caminhoFoto;

  // Construtor principal => inicializa todos os campos do registro
  PontoRegistro({
    this.id,
    required this.dataHora,
    required this.latitude,
    required this.longitude,
    required this.observacao,
    required this.caminhoFoto,
  });

  // Converte para Map => prepara os dados para inserção no SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data_hora': dataHora,
      'latitude': latitude,
      'longitude': longitude,
      'observacao': observacao,
      'caminho_foto': caminhoFoto,
    };
  }

  // Cria a partir de Map => reconstrói o objeto a partir dos dados do SQLite
  factory PontoRegistro.fromMap(Map<String, dynamic> map) {
    return PontoRegistro(
      id: map['id'] as int?,
      dataHora: map['data_hora'] as String? ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      observacao: map['observacao'] as String? ?? '',
      caminhoFoto: map['caminho_foto'] as String? ?? '',
    );
  }
}

