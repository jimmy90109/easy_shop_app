import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:easy_shop/model/message.dart';

class MessagesDatabase {
  static final MessagesDatabase instance = MessagesDatabase.init();
  static Database? _database;
  MessagesDatabase.init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    //else
    _database = await _initDB('messages.db');
    return _database!;
}

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
        path, //of the local disk
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
CREATE TABLE $tableMessages ( 
  ${MessageFields.id} $idType, 
  ${MessageFields.roomid} $integerType,
  ${MessageFields.senderid} $integerType,
  ${MessageFields.time} $textType,
  ${MessageFields.data} $textType
  )
''');
  }

  Future<Message> create(Message message) async {
    final db = await instance.database;

    final id = await db.insert(tableMessages, message.toJson());
    return message.copy(id: id);
  }

  Future<int> hasMessage(int roomid) async {
    final db = await instance.database;

    final maps = await db.query(
      tableMessages,
      columns: MessageFields.values,
      where: '${MessageFields.roomid} = ?',
      whereArgs: [roomid],
    );

    if (maps.isNotEmpty) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<String> readMessage(int roomid) async {
    final db = await instance.database;

    final maps = await db.query(
      tableMessages,
      columns: MessageFields.values,
      where: '${MessageFields.roomid} = ?',
      orderBy: '${MessageFields.time} DESC',
      whereArgs: [roomid],
    );

    if (maps.isNotEmpty) {
      return Message.fromJson(maps.first).data;
    } else {
      return "(無訊息)";
    }
  }

  Future<List<Message>> readAllMessages(int roomid) async {
    final db = await instance.database;

    final maps = await db.query(
      tableMessages,
      columns: MessageFields.values,
      where: '${MessageFields.roomid} = ?',
      orderBy: '${MessageFields.time} ASC',
      whereArgs: [roomid],
    );

    if (maps.isNotEmpty) {
      return maps.map((json) => Message.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableMessages,
      where: '${MessageFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}