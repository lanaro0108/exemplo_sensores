// Serviço de mídia => captura fotos pela câmera e salva no armazenamento local

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaService {
  static final ImagePicker _picker = ImagePicker();

  // Solicitar permissão de câmera => requisita acesso à câmera nativa
  static Future<bool> solicitarPermissaoCamera() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  // Capturar foto com câmera => abre a câmera e retorna o caminho temporário
  static Future<String?> tirarFoto() async {
    final permissao = await solicitarPermissaoCamera();
    if (!permissao) return null;

    final arquivo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (arquivo == null) return null;
    return await salvarFotoPermanente(arquivo.path);
  }

  // Salvar foto de forma permanente => copia do cache para a pasta do aplicativo
  static Future<String> salvarFotoPermanente(String caminhoTemporario) async {
    final diretorio = await getApplicationDocumentsDirectory();
    final pastaFotos = Directory('${diretorio.path}/fotos_ponto');
    if (!await pastaFotos.exists()) {
      await pastaFotos.create(recursive: true);
    }
    final nomeArquivo = 'ponto_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final destino = join(pastaFotos.path, nomeArquivo);
    final arquivoCopiado = await File(caminhoTemporario).copy(destino);
    return arquivoCopiado.path;
  }
}

