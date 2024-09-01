import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'shopping_cart.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cart_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId INTEGER,
        name TEXT,
        price REAL,
        imageUrl TEXT,
        isHot INTEGER,
        quantity INTEGER
      )
    ''');
  }

  Future<void> insertCartItem(CartItem cartItem) async {
    final db = await database;
    await db.insert(
      'cart_items',
      {
        'productId': cartItem.product.id,
        'name': cartItem.product.name,
        'price': cartItem.product.price,
        'imageUrl': cartItem.product.imageUrl,
        'isHot': cartItem.product.isHot ? 1 : 0,
        'quantity': cartItem.quantity,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart_items');

    return List.generate(maps.length, (i) {
      return CartItem(
        product: Product(
          id: maps[i]['productId'],
          name: maps[i]['name'],
          price: maps[i]['price'],
          imageUrl: maps[i]['imageUrl'],
          isHot: maps[i]['isHot'] == 1,
        ),
        quantity: maps[i]['quantity'],
      );
    });
  }

  Future<void> deleteCartItem(int id) async {
    final db = await database;
    await db.delete(
      'cart_items',
      where: 'productId = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateCartItem(CartItem cartItem) async {
    final db = await database;
    await db.update(
      'cart_items',
      {
        'productId': cartItem.product.id,
        'name': cartItem.product.name,
        'price': cartItem.product.price,
        'imageUrl': cartItem.product.imageUrl,
        'isHot': cartItem.product.isHot ? 1 : 0,
        'quantity': cartItem.quantity,
      },
      where: 'productId = ?',
      whereArgs: [cartItem.product.id],
    );
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart_items');
  }
}
