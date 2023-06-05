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
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final realType = 'REAL NOT NULL';

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
      // final json = Chatroom.toJson();
      // final columns =
      //     '${ChatroomFields.title}, ${ChatroomFields.description}, ${ChatroomFields.time}';
      // final values =
      //     '${json[ChatroomFields.title]}, ${json[ChatroomFields.description]}, ${json[ChatroomFields.time]}';
      // final id = await db
      //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

      //equal to this line
      await db.insert(tableChatrooms, chatroom.toJson());
    }
  }

  Future<List<Chatroom>> readBuyerChatroom(int id) async {
    final db = await instance.database;

    // attach 'database1.db' as db1;
    // final itemDB = await openDatabase('items.db');

    final maps = await db.rawQuery('''
SELECT $tableChatrooms.${ChatroomFields.id}, ${ChatroomFields.buyerid}, ${ChatroomFields.itemid}
FROM $tableChatrooms
INNER JOIN $tableItems
ON $tableChatrooms.${ChatroomFields.itemid} = $tableItems.${ItemFields.id}
WHERE ${ItemFields.ownerid} = $id
''');

    // db.query(
    //   tableChatrooms,
    //   columns: ChatroomFields.values,
    //   where: '${ChatroomFields.itemid} = ?',
    //   orderBy: '${ChatroomFields.id} DESC',
    //   whereArgs: [id],
    // );

    // final rawQuery = '''
    // SELECT *
    // FROM table1
    // INNER JOIN table2
    // ON table1.column_name = table2.column_name
    // ''';

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

  // Future<bool> ifChatroomExistByEmail(String email) async {
  //   // print(email);
  //   // print("checking email...");
  //   final db = await instance.database;
  //
  //   final maps = await db.query(
  //     tableChatrooms,
  //     columns: ChatroomFields.values,
  //     where: '${ChatroomFields.email} = ?',
  //     whereArgs: [email],
  //   );
  //   // print(maps);
  //   return maps.isNotEmpty ?  true : false;
  //
  // }

  // Future<Chatroom> readChatroomByEmail(String email) async {
  //   // print(email);
  //   // print("checking email...");
  //   final db = await instance.database;
  //
  //   final maps = await db.query(
  //     tableChatrooms,
  //     columns: ChatroomFields.values,
  //     where: '${ChatroomFields.email} = ?',
  //     whereArgs: [email],
  //   );
  //   // print(maps);
  //   return Chatroom.fromJson(maps.first);
  //
  // }

  // Future<String> readAllChatrooms() async {
  //
  //   final db = await instance.database;
  //
  //   final orderBy = '${ChatroomFields.id} ASC';
  //   // final result =
  //   //     await db.rawQuery('SELECT * FROM $tableChatrooms ORDER BY $orderBy');
  //
  //   final result = await db.query(tableChatrooms, orderBy: orderBy);
  //
  //   //return result.map((json) => Chatroom.fromJson(json)).toList(); //Future<List<Chatroom>>
  //   return result.toString();
  // }

  // Future<int> update(Chatroom chatroom) async {
  //   final db = await instance.database;
  //
  //   return db.update(
  //     tableChatrooms,
  //     chatroom.toJson(),
  //     where: '${ChatroomFields.id} = ?',
  //     whereArgs: [chatroom.id],
  //   );
  // }

  // Future<int> delete(int id) async {
  //   final db = await instance.database;
  //
  //   return await db.delete(
  //     tableChatrooms,
  //     where: '${ChatroomFields.id} = ?',
  //     whereArgs: [id],
  //   );
  // }
}
