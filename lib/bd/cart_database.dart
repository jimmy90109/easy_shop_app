import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/cart.dart';

class CartsDatabase {
  static final CartsDatabase instance = CartsDatabase.init();
  static Database? _database;
  CartsDatabase.init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    //else
    _database = await _initDB('carts.db');
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
    // final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    // final textType = 'TEXT NOT NULL';
    // final boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    // final realType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE $tableCarts ( 
  ${CartFields.userid} $integerType, 
  ${CartFields.itemid} $integerType,
  ${CartFields.itemNumber} $integerType,
  PRIMARY KEY (${CartFields.userid}, ${CartFields.itemid})
  )
''');
  }

  Future<Cart> create(Cart cart) async {
    final db = await instance.database;

    //print(cart);

    // final json = Cart.toJson();
    // final columns =
    //     '${CartFields.title}, ${CartFields.description}, ${CartFields.time}';
    // final values =
    //     '${json[CartFields.title]}, ${json[CartFields.description]}, ${json[CartFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    //equal to this line
    final userid = await db.insert(tableCarts, cart.toJson());
    return cart.copy(userid: userid);
  }

  Future<List<Cart>> readCart(int userid) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCarts,
      columns: CartFields.values,
      where: '${CartFields.userid} = ?',
      orderBy: '${CartFields.itemid} ASC',
      whereArgs: [userid],
    );

    if (maps.isNotEmpty) {
      return maps.map((json) => Cart.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  // Future<List<Cart>> readAllCarts() async {
  //   final db = await instance.database;
  //   final orderBy = '${CartFields.itemid} ASC';
  //   // final result =
  //   //     await db.rawQuery('SELECT * FROM $tableCarts ORDER BY $orderBy');
  //
  //   final result = await db.query(tableCarts, orderBy: orderBy);
  //   //print(result);
  //
  //   // if (result.isNotEmpty) {
  //   //   return result.map((json) => Cart.fromJson(json)).toList();
  //   // } else {
  //   //   return [];
  //   // }
  //
  //   return result.map((json) => Cart.fromJson(json)).toList();
  // }

  Future update(Cart cart) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCarts,
      columns: CartFields.values,
      where: '${CartFields.userid} = ? AND ${CartFields.itemid} = ?',
      whereArgs: [cart.userid, cart.itemid]
    );

    if (maps.isNotEmpty) {
      int num = Cart.fromJson(maps.first).itemNumber;
      num++;
      Cart temp = Cart(userid: cart.userid, itemid: cart.itemid, itemNumber: num);
      await db.update(
          tableCarts,
          temp.toJson(),
          where: '${CartFields.userid} = ? AND ${CartFields.itemid} = ?',
          whereArgs: [cart.userid, cart.itemid]
      );
    } else {
      await db.insert(tableCarts, cart.toJson());
    }

  }

  Future<int> delete(int userid, int itemid) async {
    final db = await instance.database;

    return await db.delete(
      tableCarts,
      where: '${CartFields.userid} = ? AND ${CartFields.itemid} = ?',
      whereArgs: [userid, itemid]
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}