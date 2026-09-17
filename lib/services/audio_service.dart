// Serviço de som => emite feedback sonoro de confirmação usando audioplayers

import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  // Tocar som de confirmação => emite sinal sonoro de registro salvo
  static Future<void> tocarConfirmacao() async {
    try {
      SystemSound.play(SystemSoundType.click);
      final bytesWav = _gerarBipeWav();
      await _player.play(BytesSource(bytesWav));
    } catch (_) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  // Gerar bipe senoidal em memória => dispensa assets externos e funciona offline
  static Uint8List _gerarBipeWav() {
    const int taxaAmostragem = 8000;
    const double duracao = 0.15;
    final int totalAmostras = (taxaAmostragem * duracao).toInt();
    final ByteData header = ByteData(44);
    _escreverCabecalhoWav(header, totalAmostras);
    final Uint8List audioData = Uint8List(44 + totalAmostras);
    audioData.setRange(0, 44, header.buffer.asUint8List());
    for (int i = 0; i < totalAmostras; i++) {
      final double seno = sin(2 * pi * 880 * (i / taxaAmostragem));
      audioData[44 + i] = ((seno + 1.0) * 127.5).toInt();
    }
    return audioData;
  }

  // Escrever cabeçalho WAV => monta os metadados do arquivo de áudio PCM
  static void _escreverCabecalhoWav(ByteData b, int amostras) {
    b.setUint32(0, 0x52494646, Endian.big); // 'RIFF'
    b.setUint32(4, 36 + amostras, Endian.little);
    b.setUint32(8, 0x57415645, Endian.big); // 'WAVE'
    b.setUint32(12, 0x666d7420, Endian.big); // 'fmt '
    b.setUint32(16, 16, Endian.little);
    b.setUint16(20, 1, Endian.little); // PCM
    b.setUint16(22, 1, Endian.little); // 1 Canal
    b.setUint32(24, 8000, Endian.little); // Taxa
    b.setUint32(28, 8000, Endian.little);
    b.setUint16(32, 1, Endian.little);
    b.setUint16(34, 8, Endian.little); // 8 bits
    b.setUint32(36, 0x64617461, Endian.big); // 'data'
    b.setUint32(40, amostras, Endian.little);
  }
}

