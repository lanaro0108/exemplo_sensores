// Tela de novo registro => captura foto, obtém GPS e salva no banco local

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/ponto_registro.dart';
import '../services/audio_service.dart';
import '../services/db_service.dart';
import '../services/location_service.dart';
import '../services/media_service.dart';

class NovoRegistroScreen extends StatefulWidget {
  const NovoRegistroScreen({super.key});

  @override
  State<NovoRegistroScreen> createState() => _NovoRegistroScreenState();
}

class _NovoRegistroScreenState extends State<NovoRegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _observacaoController = TextEditingController();
  String? _caminhoFoto;
  Position? _posicaoAtual;
  bool _carregandoGps = false;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _buscarGps();
  }

  @override
  void dispose() {
    _observacaoController.dispose();
    super.dispose();
  }

  // Buscar localização atual => invoca o GPS e atualiza as coordenadas na tela
  Future<void> _buscarGps() async {
    setState(() => _carregandoGps = true);
    final posicao = await LocationService.obterPosicaoAtual();
    setState(() {
      _posicaoAtual = posicao;
      _carregandoGps = false;
    });
    if (posicao == null && mounted) {
      _exibirMensagem('Não foi possível obter GPS. Verifique se está ativado.');
    }
  }

  // Capturar foto => abre a câmera nativa e armazena o caminho obtido
  Future<void> _tirarFoto() async {
    final caminho = await MediaService.tirarFoto();
    if (caminho != null) {
      setState(() => _caminhoFoto = caminho);
    }
  }

  // Salvar registro de ponto => persiste dados no SQLite e emite confirmação
  Future<void> _salvarRegistro() async {
    if (_caminhoFoto == null) return _exibirMensagem('Tire uma foto para registrar.');
    if (_posicaoAtual == null) return _exibirMensagem('Aguarde o sinal de GPS.');
    setState(() => _salvando = true);
    final dataHoraFormatada = DateTime.now().toLocal().toString().split('.')[0];
    final novoPonto = PontoRegistro(
      dataHora: dataHoraFormatada,
      latitude: _posicaoAtual!.latitude,
      longitude: _posicaoAtual!.longitude,
      observacao: _observacaoController.text.trim(),
      caminhoFoto: _caminhoFoto!,
    );
    await DbService.instancia.inserirRegistro(novoPonto);
    await AudioService.tocarConfirmacao();
    if (mounted) {
      _exibirMensagem('Ponto registrado com sucesso!');
      Navigator.pop(context, true);
    }
  }

  // Exibir mensagem na tela => mostra SnackBar informativo ao usuário
  void _exibirMensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Registro de Ponto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _construirCardFoto(),
              const SizedBox(height: 16),
              _construirCardGps(),
              const SizedBox(height: 16),
              _construirCampoObservacao(),
              const SizedBox(height: 20),
              _construirBotaoSalvar(),
            ],
          ),
        ),
      ),
    );
  }

  // Construir card de foto => exibe preview da imagem ou botão para câmera
  Widget _construirCardFoto() {
    return InkWell(
      onTap: _tirarFoto,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: _caminhoFoto != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(_caminhoFoto!), fit: BoxFit.cover),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 50, color: Colors.blueGrey),
                  SizedBox(height: 8),
                  Text('Toque para tirar a foto do ponto'),
                ],
              ),
      ),
    );
  }

  // Construir card de GPS => exibe coordenadas capturadas e botão de atualizar
  Widget _construirCardGps() {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(
          _posicaoAtual != null ? Icons.location_on : Icons.location_off,
          color: _posicaoAtual != null ? Colors.green : Colors.red,
        ),
        title: const Text('Localização GPS'),
        subtitle: _carregandoGps
            ? const Text('Buscando sinal de satélite...')
            : Text(
                _posicaoAtual != null
                    ? 'Lat: ${_posicaoAtual!.latitude.toStringAsFixed(5)}\nLong: ${_posicaoAtual!.longitude.toStringAsFixed(5)}'
                    : 'GPS não obtido.',
              ),
        trailing: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _carregandoGps ? null : _buscarGps,
        ),
      ),
    );
  }

  // Construir campo de texto => permite digitar o diário de campo ou observação
  Widget _construirCampoObservacao() {
    return TextFormField(
      controller: _observacaoController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Observação / Diário de Campo',
        border: OutlineInputBorder(),
        hintText: 'Ex: Visita técnica na unidade SENAI ou conferência de maquinário',
      ),
    );
  }

  // Construir botão de salvar => aciona a gravação do registro
  Widget _construirBotaoSalvar() {
    return ElevatedButton.icon(
      onPressed: _salvando ? null : _salvarRegistro,
      icon: _salvando
          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.check),
      label: Text(_salvando ? 'Salvando...' : 'Salvar Registro'),
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
    );
  }
}

