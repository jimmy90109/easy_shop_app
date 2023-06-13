import 'package:easy_shop/bd/chatroom_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/item.dart';

class ItemsDatabase {
  static final ItemsDatabase instance = ItemsDatabase.init();
  static Database? _database;
  ItemsDatabase.init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    //else
    _database = await _initDB('items.db');
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
CREATE TABLE $tableItems ( 
  ${ItemFields.id} $idType, 
  ${ItemFields.ownerid} $integerType,
  ${ItemFields.name} $textType,
  ${ItemFields.description} $textType,
  ${ItemFields.price} $integerType,
  ${ItemFields.imageURL} $textType,
  ${ItemFields.inventory} $integerType
  )
''');
  }

  Future<Item> create(Item item) async {
    final db = await instance.database;

    final id = await db.insert(tableItems, item.toJson());
    await ChatroomsDatabase.instance.syncItems(id, item.name, item.ownerid, item.imageURL);

    return item.copy(id: id);
  }

  Future<Item> readItem(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableItems,
      columns: ItemFields.values,
      where: '${ItemFields.id} = ?',
      whereArgs: [id]
    );

    if (maps.isNotEmpty) {
      return Item.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Item>> readAllItems() async {
    final db = await instance.database;
    const orderBy = '${ItemFields.id} ASC';

    final result = await db.query(tableItems, orderBy: orderBy);

    return result.map((json) => Item.fromJson(json)).toList();
  }

  Future<int> update(Item item) async {
    final db = await instance.database;

    return await db.update(
      tableItems,
      item.toJson(),
      where: '${ItemFields.id} = ?',
      whereArgs: [item.id]
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableItems,
      where: '${ItemFields.id} = ?',
      whereArgs: [id]
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}