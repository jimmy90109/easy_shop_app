import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/order.dart';

class OrdersDatabase {
  static final OrdersDatabase instance = OrdersDatabase.init();
  static Database? _database;
  OrdersDatabase.init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    //else
    _database = await _initDB('orders.db');
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
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    // final realType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE $tableOrders ( 
  ${OrderFields.id} $idType, 
  ${OrderFields.buyerid} $integerType,
  ${OrderFields.sellerid} $integerType,
  ${OrderFields.time} $textType,
  ${OrderFields.address} $textType,
  ${OrderFields.itemid} $integerType,
  ${OrderFields.itemNumber} $integerType,
  ${OrderFields.completed} $boolType
  )
''');
  }

  Future<Order> create(Order order) async {
    final db = await instance.database;

    //print(order);

    // final json = Order.toJson();
    // final columns =
    //     '${OrderFields.title}, ${OrderFields.description}, ${OrderFields.time}';
    // final values =
    //     '${json[OrderFields.title]}, ${json[OrderFields.description]}, ${json[OrderFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    //equal to this line
    final id = await db.insert(tableOrders, order.toJson());
    return order.copy(id: id);
  }

  Future<List<Order>> readOrder(int userid) async {
    final db = await instance.database;

    final maps = await db.query(
      tableOrders,
      columns: OrderFields.values,
      where: '${OrderFields.buyerid} = ?',
      orderBy: '${OrderFields.time} DESC',
      whereArgs: [userid],
    );

    if (maps.isNotEmpty) {
      return maps.map((json) => Order.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  // Future<List<Order>> readAllOrders() async {
  //   final db = await instance.database;
  //   final orderBy = '${OrderFields.time} ASC';
  //   // final result =
  //   //     await db.rawQuery('SELECT * FROM $tableOrders ORDER BY $orderBy');
  //
  //   final result = await db.query(tableOrders, orderBy: orderBy);
  //   //print(result);
  //
  //   // if (result.isNotEmpty) {
  //   //   return result.map((json) => Order.fromJson(json)).toList();
  //   // } else {
  //   //   return [];
  //   // }
  //
  //   return result.map((json) => Order.fromJson(json)).toList();
  // }

  Future update(Order order) async {
    final db = await instance.database;

    // final maps = await db.query(
    //   tableOrders,
    //   columns: OrderFields.values,
    //   where: '${OrderFields.id} = ?',
    //   whereArgs: [orderid],
    // );
    //
    // Order temp = Order.fromJson(maps.first);
    //
    // Order newOrder = Order(
    //     id: orderid,
    //     buyerid: temp.buyerid,
    //     sellerid: temp.sellerid,
    //     time: temp.time,
    //     address: temp.address,
    //     itemid: temp.itemid,
    //     itemNumber: temp.itemNumber,
    //     completed: true);

    await db.update(tableOrders, order.toJson(),
        where: '${OrderFields.id} = ?', whereArgs: [order.id]);

    final maps = await db.query(
          tableOrders,
          columns: OrderFields.values,
          where: '${OrderFields.id} = ?',
          whereArgs: [order.id],
        );
    print(maps);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db
        .delete(tableOrders, where: '${OrderFields.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
