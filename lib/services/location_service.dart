// Serviço de localização => obtém coordenadas do GPS com validação de permissões

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  // Verificar serviço de GPS => checa se o hardware de localização está ligado
  static Future<bool> verificarServicoAtivo() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Solicitar permissão de GPS => pede acesso à localização em tempo de execução
  static Future<bool> solicitarPermissao() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  // Obter posição atual => recupera latitude e longitude com alta precisão
  static Future<Position?> obterPosicaoAtual() async {
    final servicoAtivo = await verificarServicoAtivo();
    if (!servicoAtivo) return null;

    final permissaoConcedida = await solicitarPermissao();
    if (!permissaoConcedida) return null;

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }
}

