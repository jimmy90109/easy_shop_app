import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:easy_shop/model/buyer.dart';

class BuyersDatabase {
  static final BuyersDatabase instance = BuyersDatabase.init();
  static Database? _database;
  BuyersDatabase.init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    //else
    _database = await _initDB('buyers.db');
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
    const realType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE $tableBuyers ( 
  ${BuyerFields.id} $idType, 
  ${BuyerFields.name} $textType,
  ${BuyerFields.phone} $textType,
  ${BuyerFields.email} $textType,
  ${BuyerFields.password} $textType,
  ${BuyerFields.review} $realType,
  ${BuyerFields.reviewCount} $integerType
  )
''');
  }

  Future<Buyer> create(Buyer buyer) async {
    final db = await instance.database;

    // final json = Buyer.toJson();
    // final columns =
    //     '${BuyerFields.title}, ${BuyerFields.description}, ${BuyerFields.time}';
    // final values =
    //     '${json[BuyerFields.title]}, ${json[BuyerFields.description]}, ${json[BuyerFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');

    //equal to this line
    final id = await db.insert(tableBuyers, buyer.toJson());

    return buyer.copy(id: id);
  }

  Future<bool> ifBuyerExistByEmail(String email) async {
    final db = await instance.database;

    final maps = await db.query(
      tableBuyers,
      columns: BuyerFields.values,
      where: '${BuyerFields.email} = ?',
      whereArgs: [email],
    );

    return maps.isNotEmpty ?  true : false;
  }

  Future<Buyer> readBuyerByEmail(String email) async {
    final db = await instance.database;

    final maps = await db.query(
      tableBuyers,
      columns: BuyerFields.values,
      where: '${BuyerFields.email} = ?',
      whereArgs: [email],
    );

    return Buyer.fromJson(maps.first);
  }

  Future<Buyer> readBuyer(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableBuyers,
      columns: BuyerFields.values,
      where: '${BuyerFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Buyer.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<String> readAllBuyers() async {

    final db = await instance.database;

    final orderBy = '${BuyerFields.id} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableBuyers ORDER BY $orderBy');

    final result = await db.query(tableBuyers, orderBy: orderBy);

    //return result.map((json) => Buyer.fromJson(json)).toList(); //Future<List<Buyer>>
    return result.toString();
  }

  Future<int> update(Buyer buyer) async {
    final db = await instance.database;

    return db.update(
      tableBuyers,
      buyer.toJson(),
      where: '${BuyerFields.id} = ?',
      whereArgs: [buyer.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableBuyers,
      where: '${BuyerFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}