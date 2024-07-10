import 'package:sqflite/sqflite.dart' as sql;
import 'package:swe2109772_assignment1/models/item_model.dart';

class DatabaseService {
  static Future<void> createUserTable(sql.Database database) async {
    await database.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        username TEXT UNIQUE,
        email TEXT,
        phoneNo TEXT,
        password TEXT
      )
    ''');
  }

  static Future<void> createCartTable(sql.Database database) async {
    await database.execute('''
      CREATE TABLE cart(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        imgPath TEXT,
        price TEXT,
        description TEXT,
        quantity INTEGER
      )
    ''');
  }

  static Future<void> createFavoritesTable(sql.Database database) async {
    await database.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        imgPath TEXT,
        price TEXT,
        description TEXT,
        isFavorited INTEGER,
        UNIQUE (name, imgPath)
      )
    ''');
  }

  static Future<sql.Database> db() async {
    final databasePath = await sql.getDatabasesPath();
    final path = '$databasePath/user.db';

    return sql.openDatabase(
      path,
      version: 2, // Increment version to trigger onUpgrade
      onCreate: (sql.Database database, int version) async {
        await createUserTable(database);
        await createCartTable(database);
        await createFavoritesTable(database);
      },
      onUpgrade: (sql.Database database, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          // Add the phoneNo column to the users table
          await database.execute('ALTER TABLE users ADD COLUMN phoneNo TEXT');
        }
      },
    );
  }

  static Future<int> createUser(String username, String email, String phoneNo, String password) async {
    final db = await DatabaseService.db();
    final data = {'username': username, 'email': email, 'phoneNo': phoneNo, 'password': password};

    final id = await db.insert('users', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<Map<String, dynamic>?> getUser(String username) async {
    final db = await DatabaseService.db();
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  static Future<int> createFavorite(Item item) async {
    final db = await DatabaseService.db();
    final data = {
      'name': item.name,
      'imgPath': item.imgPath,
      'price': item.price,
      'description': item.description,
      'isFavorited': item.isFavorited ? 1 : 0
    };

    try {
      final id = await db.insert('favorites', data, conflictAlgorithm: sql.ConflictAlgorithm.ignore);
      return id;
    } catch (e) {
      // Handle the case where the item is already in the favorites table
      print('Item is already in favorites: ${e.toString()}');
      return -1;
    }
  }

  static Future<void> deleteFavorite(Item item) async {
    final db = await DatabaseService.db();
    await db.delete(
      'favorites',
      where: 'name = ? AND imgPath = ?',
      whereArgs: [item.name, item.imgPath],
    );
  }

  static Future<List<Item>> getFavorites() async {
    final db = await DatabaseService.db();
    final List<Map<String, dynamic>> maps = await db.query('favorites');

    return List.generate(maps.length, (i) {
      return Item(
        id: maps[i]['id'],
        name: maps[i]['name'],
        imgPath: maps[i]['imgPath'],
        price: maps[i]['price'],
        description: maps[i]['description'],
        isFavorited: maps[i]['isFavorited'] == 1,
      );
    });
  }

  static Future<void> updateFavoriteStatus(Item item) async {
    final db = await DatabaseService.db();
    final data = {
      'isFavorited': item.isFavorited ? 1 : 0,
    };

    await db.update(
      'favorites',
      data,
      where: 'name = ? AND imgPath = ?',
      whereArgs: [item.name, item.imgPath],
    );
  }

  static Future<int> addCartItem(Item item) async {
    final db = await DatabaseService.db();
    final data = {
      'name': item.name,
      'imgPath': item.imgPath,
      'price': item.price,
      'description': item.description,
      'quantity': item.quantity
    };

    final id = await db.insert('cart', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<void> deleteCartItem(Item item) async {
    final db = await DatabaseService.db();
    await db.delete(
      'cart',
      where: 'name = ? AND imgPath = ? AND price = ? AND description = ?',
      whereArgs: [item.name, item.imgPath, item.price, item.description],
    );
  }

  static Future<List<Item>> getCartItems() async {
    final db = await DatabaseService.db();
    final List<Map<String, dynamic>> maps = await db.query('cart');

    return List.generate(maps.length, (i) {
      return Item(
        name: maps[i]['name'],
        imgPath: maps[i]['imgPath'],
        price: maps[i]['price'],
        description: maps[i]['description'],
        quantity: maps[i]['quantity'],
      );
    });
  }
}
