// Tela inicial => exibe o histórico de registros de ponto e diário de campo

import 'dart:io';
import 'package:flutter/material.dart';
import '../models/ponto_registro.dart';
import '../services/db_service.dart';
import 'detalhe_screen.dart';
import 'novo_registro_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PontoRegistro> _registros = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarRegistros();
  }

  // Carregar registros do banco => busca os pontos salvos no SQLite
  Future<void> _carregarRegistros() async {
    setState(() => _carregando = true);
    final lista = await DbService.instancia.listarRegistros();
    setState(() {
      _registros = lista;
      _carregando = false;
    });
  }

  // Abrir tela de cadastro => aguarda retorno para atualizar a listagem
  Future<void> _abrirNovoRegistro() async {
    final salvou = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => NovoRegistroScreen()),
    );
    if (salvou == true) _carregarRegistros();
  }

  // Excluir registro do SQLite => remove o ponto selecionado da base
  Future<void> _excluirRegistro(int id) async {
    await DbService.instancia.excluirRegistro(id);
    _carregarRegistros();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro removido com sucesso.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SENAI CheckIn'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _carregarRegistros,
            tooltip: 'Atualizar Lista',
          ),
        ],
      ),
      body: _construirCorpo(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirNovoRegistro,
        icon: Icon(Icons.add_a_photo),
        label: Text('Novo Ponto'),
      ),
    );
  }

  // Construir corpo da tela => alterna entre carregamento, vazio ou lista
  Widget _construirCorpo() {
    if (_carregando) {
      return Center(child: CircularProgressIndicator());
    }
    if (_registros.isEmpty) {
      return Center(
        child: Text(
          'Nenhum registro encontrado.\nToque no botão abaixo para adicionar.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: _registros.length,
      padding: EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) => _construirItemLista(_registros[index]),
    );
  }

  // Construir miniatura da foto => desenha a prévia no card
  Widget _construirMiniatura(String caminho) {
    final arquivo = File(caminho);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 55,
        height: 55,
        child: arquivo.existsSync()
            ? Image.file(arquivo, fit: BoxFit.cover)
            : Container(color: Colors.grey.shade300, child: Icon(Icons.broken_image)),
      ),
    );
  }

  // Construir item da lista => apresenta informações resumidas do registro
  Widget _construirItemLista(PontoRegistro item) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: _construirMiniatura(item.caminhoFoto),
        title: Text(item.dataHora, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          'Lat: ${item.latitude.toStringAsFixed(4)} | Long: ${item.longitude.toStringAsFixed(4)}\n'
          '${item.observacao.isEmpty ? "Sem observação" : item.observacao}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: true,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetalheScreen(registro: item)),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => item.id != null ? _excluirRegistro(item.id!) : null,
        ),
      ),
    );
  }
}

