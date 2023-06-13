import 'package:easy_shop/model/item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:easy_shop/model/chatroom.dart';

class ChatroomsDatabase {
  static final ChatroomsDatabase instance = ChatroomsDatabase.init();
  static Database? _database;
  ChatroomsDatabase.init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    //else
    _database = await _initDB('chatrooms.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, //of the local disk
        version: 1, //can upgrade schema by this version
        onCreate: _createDB //only the first time
        );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    // const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    // const realType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE $tableChatrooms ( 
  ${ChatroomFields.id} $idType, 
  ${ChatroomFields.buyerid} $integerType,
  ${ChatroomFields.itemid} $integerType
  )
''');

    await db.execute('''
CREATE TABLE $tableItems ( 
  ${ItemFields.id} $idType, 
  ${ItemFields.name} $textType,
  ${ItemFields.ownerid} $integerType,
  ${ItemFields.imageURL} $textType
  )
''');
  }

  Future syncItems(int id, String name, int owner, String URL) async {
    final db = await instance.database;

    await db.rawInsert(
        'INSERT INTO $tableItems (${ItemFields.id}, ${ItemFields.name}, ${ItemFields.ownerid}, ${ItemFields.imageURL}) VALUES (?, ?, ?, ?)',
        [id, name, owner, URL]);
  }

  Future create(Chatroom chatroom) async {
    final db = await instance.database;

    final maps = await db.query(
      tableChatrooms,
      columns: ChatroomFields.values,
      where: '${ChatroomFields.buyerid} = ? AND ${ChatroomFields.itemid} = ?',
      whereArgs: [chatroom.buyerid, chatroom.itemid],
    );

    if (maps.isEmpty) {
      await db.insert(tableChatrooms, chatroom.toJson());
    }
  }

  Future<List<Chatroom>> readBuyerChatroom(int id) async {
    final db = await instance.database;

    final maps = await db.rawQuery('''
SELECT $tableChatrooms.${ChatroomFields.id}, ${ChatroomFields.buyerid}, ${ChatroomFields.itemid}
FROM $tableChatrooms
INNER JOIN $tableItems
ON $tableChatrooms.${ChatroomFields.itemid} = $tableItems.${ItemFields.id}
WHERE ${ItemFields.ownerid} = $id
''');

    if (maps.isNotEmpty) {
      return maps.map((json) => Chatroom.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<List<Chatroom>> readSellerChatroom(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableChatrooms,
      columns: ChatroomFields.values,
      where: '${ChatroomFields.buyerid} = ?',
      orderBy: '${ChatroomFields.id} DESC',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.map((json) => Chatroom.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

}
