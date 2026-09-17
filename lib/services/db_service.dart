// Serviço de banco de dados => gerencia as operações locais com SQLite

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/ponto_registro.dart';

class DbService {
  // Padrão Singleton => garante instância única para gerenciar a conexão
  static final DbService instancia = DbService._interno();
  static Database? _bancoDados;

  DbService._interno();

  // Obter conexão => retorna o banco já aberto ou inicia uma nova conexão
  Future<Database> get database async {
    if (_bancoDados != null) return _bancoDados!;
    _bancoDados = await _iniciarBanco();
    return _bancoDados!;
  }

  // Inicializar o banco => define o caminho físico e a versão da base
  Future<Database> _iniciarBanco() async {
    final caminhoPastas = await getDatabasesPath();
    final caminhoCompleto = join(caminhoPastas, 'senai_checkin.db');
    return await openDatabase(
      caminhoCompleto,
      version: 1,
      onCreate: _criarTabelas,
    );
  }

  // Criar tabelas => cria a estrutura para armazenar os registros
  Future<void> _criarTabelas(Database db, int versao) async {
    await db.execute('''
      CREATE TABLE registros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data_hora TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        observacao TEXT NOT NULL,
        caminho_foto TEXT NOT NULL
      )
    ''');
  }

  // Inserir registro => adiciona novo ponto ou visita no banco local
  Future<int> inserirRegistro(PontoRegistro registro) async {
    final db = await database;
    return await db.insert(
      'registros',
      registro.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Listar registros => busca todos os registros ordenados do mais recente
  Future<List<PontoRegistro>> listarRegistros() async {
    final db = await database;
    final resultado = await db.query('registros', orderBy: 'id DESC');
    return resultado.map((mapa) => PontoRegistro.fromMap(mapa)).toList();
  }

  // Excluir registro => remove um ponto selecionado pelo identificador
  Future<int> excluirRegistro(int id) async {
    final db = await database;
    return await db.delete(
      'registros',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

