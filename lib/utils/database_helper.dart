import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:movie_app/models/movie.dart';

class DatabaseHelper{
  static const _databaseName = 'MovieData.db';
  static const _databaseVersion = 1;

  //singleton class
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  
  late Database _database;
  Future<Database> get database async{
    if(_database!= null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async{
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join (dataDirectory.path,_databaseName);
    return await openDatabase(dbPath,version:_databaseVersion,onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int version) async{

    await db.execute('''
      CREATE TABLE ${Movie.tblMovie}(
        ${Movie.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Movie.colTitle} TEXT NOT NULL,
        ${Movie.colDesc} TEXT NOT NULL,
        ${Movie.colStock} INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertMovie(Movie movie) async{
    Database db = await database;
    return await db.insert(Movie.tblMovie, movie.toMap());
  }
  Future<int> updateMovie(Movie movie) async{
    Database db = await database;
    return await db.update(Movie.tblMovie, movie.toMap(),
    where: '${Movie.colId}=?', whereArgs: [movie.id]);
  }
  Future<int> deleteMovie(int id) async{
    Database db = await database;
    return await db.delete(Movie.tblMovie,
    where: '${Movie.colId}=?', whereArgs: [id]);
  }
  Future<List<Movie>> fetchMovies() async{
    Database db = await database;
    List<Map> movies = await db.query(Movie.tblMovie);
    return movies.length == 0
    ? []
    : movies.map((e) => Movie.fromMap(e)).toList();
  }
}