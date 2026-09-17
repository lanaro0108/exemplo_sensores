// Testes unitários => valida a integridade do modelo de dados PontoRegistro

import 'package:flutter_test/flutter_test.dart';
import 'package:exemplo_bluetooth/models/ponto_registro.dart';

void main() {
  test('Deve converter PontoRegistro para Map e reconstruir a partir de Map', () {
    final pontoOriginal = PontoRegistro(
      id: 1,
      dataHora: '2026-09-17 10:00:00',
      latitude: -23.55052,
      longitude: -46.63330,
      observacao: 'Visita técnica realizada',
      caminhoFoto: '/caminho/foto.jpg',
    );

    final mapa = pontoOriginal.toMap();
    final pontoReconstruido = PontoRegistro.fromMap(mapa);

    expect(pontoReconstruido.id, 1);
    expect(pontoReconstruido.dataHora, '2026-09-17 10:00:00');
    expect(pontoReconstruido.latitude, -23.55052);
    expect(pontoReconstruido.longitude, -46.63330);
    expect(pontoReconstruido.observacao, 'Visita técnica realizada');
    expect(pontoReconstruido.caminhoFoto, '/caminho/foto.jpg');
  });
}

