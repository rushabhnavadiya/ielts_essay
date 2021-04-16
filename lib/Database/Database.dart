

import 'dart:io';

import 'package:ielts_essay/Model/QuestionModel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  static final String dbName = 'EssayData.db';
  static final int dbVersion = 1;

//////////////////// Question /////////////////////////
  final String questionTable = 'question_table';
  final String colQueId = 'id';
  final String colQueTypeId = 'type_id';
  final String colQueQuestion = 'question';
  final String colQueSaved = 'is_save';
  final String colQueFavourite = 'is_fav';
///////////////////////////////////////////////////////

/*
//////////////////// Answer ////////////////////////
  final String answerTable = 'answer_table';
  final String colAnsId = 'ans_id';
  final String colAnsQuestionId = 'question_id';
  final String colAnsIsSuggestion = 'is_suggestion';
  final String colAnsAnswer = 'answer';
  final String colAnsSaved = 'is_save';
  final String colAnsFavourite = 'is_fav';
////////////////////////////////////////////////////

//////////////////// Suggestion ////////////////////////
  final String suggestionTable = 'suggestion_table';
  final String colSugId = 'sug_id';
  final String colSugAnswerId = 'answer_id';
  final String colSugSuggestion = 'suggestion';
  final String colSugQuestion = 'question';
  final String colSugSaved = 'is_save';
  final String colSugFavourite = 'is_fav';
////////////////////////////////////////////////////////

//////////////////// Essay ////////////////////////
  final String essayTable = 'essay_table';
  final String colEssayId = 'essay_id';
  final String colEssayAnswerId = 'answer_id';
  final String colEssaySuggestionId = 'suggestion_id';
  final String colEssayQuestionId = 'question_id';
  final String colEssaySaved = 'is_save';
  final String colEssayFavourite = 'is_fav';
///////////////////////////////////////////////////
*/

  // Make this a singleton class.
  DatabaseHelper.privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async{
    if(_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,dbName);

    return await openDatabase(path,version: dbVersion,onCreate: _onCreate,onUpgrade: _onUpgrade);
  }

  Future _onCreate(Database db,int version) async{
    await db.execute('''
          CREATE TABLE $questionTable(
         't_id' INTEGER PRIMARY KEY AUTOINCREMENT,
          $colQueId TEXT NOT NULL,
          $colQueTypeId TEXT NOT NULL,
          $colQueQuestion TEXT NOT NULL,
          $colQueSaved TEXT NOT NULL,
          $colQueFavourite TEXT NOT NULL
          )
    ''');

/*    await db.execute('''
          CREATE TABLE $answerTable(
         'id' INTEGER PRIMARY KEY AUTOINCREMENT,
          $colAnsId TEXT NOT NULL,
          $colAnsQuestionId TEXT NOT NULL,
          $colAnsIsSuggestion TEXT NOT NULL,
          $colAnsAnswer TEXT NOT NULL,
          $colAnsSaved TEXT NOT NULL,
          $colAnsFavourite TEXT NOT NULL
          )
    ''');

    await db.execute('''
          CREATE TABLE $suggestionTable(
         'id' INTEGER PRIMARY KEY AUTOINCREMENT,
          $colSugId TEXT NOT NULL,
          $colSugAnswerId TEXT NOT NULL,
          $colSugSuggestion TEXT NOT NULL,
          $colSugQuestion TEXT NOT NULL,
          $colSugSaved TEXT NOT NULL,
          $colSugFavourite TEXT NOT NULL
          )
    ''');

    await db.execute('''
          CREATE TABLE $essayTable(
         'id' INTEGER PRIMARY KEY AUTOINCREMENT,
          $colEssayId TEXT NOT NULL,
          $colEssayAnswerId TEXT NOT NULL,
          $colEssaySuggestionId TEXT NOT NULL,
          $colEssayQuestionId TEXT NOT NULL,
          $colEssaySaved TEXT NOT NULL,
          $colEssayFavourite TEXT NOT NULL
          )
    ''');*/
  }
  void _onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {
      // Upgrade your DB schema
    }
  }

  Future insertQuestion(QuestionModel question) async{
    Database db = await database;
    var res = await db.query(questionTable, where: '$colQueId = ?', whereArgs: [question.id]);
    var result;
    if(res.isNotEmpty){
      result = await db.update(questionTable, question.toJson(), where: '$colQueId = ?', whereArgs: [question.id]);
    }else{
      result = await db.insert(questionTable, question.toJson());
    }
    return result;
  }
  Future<List<QuestionModel>> getQuestions() async{
    Database db = await database;
    var res = await db.query(questionTable);
    List<QuestionModel> list = res.isNotEmpty?res.map((e) => QuestionModel.fromJson(e)).toList():[];
    return list;
  }

  Future<List<QuestionModel>> getSavedQuestions() async{
    Database db = await database;
    var res = await db.query(questionTable, where: '$colQueSaved = ?', whereArgs: ['1']);
    List<QuestionModel> list = res.isNotEmpty?res.map((e) => QuestionModel.fromJson(e)).toList():[];
    return list;
  }
  Future<List<QuestionModel>> getFavouriteQuestions() async{
    Database db = await database;
    var res = await db.query(questionTable, where: '$colQueFavourite = ?', whereArgs: ['1']);
    List<QuestionModel> list = res.isNotEmpty?res.map((e) => QuestionModel.fromJson(e)).toList():[];
    return list;
  }

  Future<int> updateSavedQuestions(String id) async {
    Database db = await database;
    var result = await db.rawUpdate('UPDATE $questionTable SET $colQueSaved = 0 WHERE id = $id');
    deleteQuestions(id);
    return result;
  }
  Future<int> updateFavouriteQuestions(String id) async {
    Database db = await database;
    var result = await db.rawUpdate('UPDATE $questionTable SET $colQueFavourite = 0 WHERE id = $id');
    deleteQuestions(id);
    return result;
  }

  Future<int> deleteQuestions(String id) async {
    Database db = await database;
    var result = await db.rawDelete('DELETE FROM $questionTable WHERE $colQueFavourite = 0 AND $colQueSaved = 0');
    /*var result = await db.delete(
        questionTable,
        where: 'id = ?',
        whereArgs: [id]);*/
    return result;
  }
}