// Tela de detalhes => exibe as informações completas do registro e mapa

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/ponto_registro.dart';

class DetalheScreen extends StatelessWidget {
  final PontoRegistro registro;

  const DetalheScreen({super.key, required this.registro});

  // Abrir mapa nativo => abre o Google Maps ou app padrão com as coordenadas
  Future<void> _abrirMapa(BuildContext context) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${registro.latitude},${registro.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o mapa.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Registro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _construirFoto(),
            const SizedBox(height: 16),
            _construirCardInfo(),
            const SizedBox(height: 16),
            _construirBotaoMapa(context),
          ],
        ),
      ),
    );
  }

  // Construir visualização da foto => exibe a imagem capturada em destaque
  Widget _construirFoto() {
    final arquivo = File(registro.caminhoFoto);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: arquivo.existsSync()
          ? Image.file(arquivo, height: 260, fit: BoxFit.cover)
          : Container(
              height: 200,
              color: Colors.grey.shade300,
              child: const Icon(Icons.broken_image, size: 60),
            ),
    );
  }

  // Construir card com dados => exibe data, coordenadas e diário
  Widget _construirCardInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data e Hora: ${registro.dataHora}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Latitude: ${registro.latitude}'),
            Text('Longitude: ${registro.longitude}'),
            const Divider(height: 24),
            const Text('Observação / Diário:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(registro.observacao.isEmpty ? 'Sem observações.' : registro.observacao),
          ],
        ),
      ),
    );
  }

  // Construir botão de mapa => aciona o aplicativo de mapas externo
  Widget _construirBotaoMapa(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _abrirMapa(context),
      icon: const Icon(Icons.map),
      label: const Text('Visualizar no Mapa'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}

