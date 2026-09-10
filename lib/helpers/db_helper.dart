import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();

  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('smart_cart.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE master_products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        description TEXT,
        image TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE local_cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE master_products ADD COLUMN image TEXT',
      );
    }
  }

  Future<int> insertProduct(
    Map<String, dynamic> product,
  ) async {
    final db = await database;

    return await db.insert(
      'master_products',
      product,
    );
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;

    return await db.query(
      'master_products',
      orderBy: 'id ASC',
    );
  }

  Future<int> insertCart(
    Map<String, dynamic> cart,
  ) async {
    final db = await database;

    return await db.insert(
      'local_cart',
      cart,
    );
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    final db = await database;

    return await db.query(
      'local_cart',
    );
  }

  Future<int> updateCartQuantity(
    int id,
    int quantity,
  ) async {
    final db = await database;

    return await db.update(
      'local_cart',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCartItem(int id) async {
    final db = await database;

    return await db.delete(
      'local_cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}