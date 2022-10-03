import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:warehouse/model/warehouse.dart';

import '../model/buy_sell_product.dart';
import '../model/produt.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static const String _dbName = "Product.db";
  static const int _dbVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (Database db, int version) async {
        final String integer = "INTEGER";
        final String text = "TEXT";

        await db.execute('''CREATE TABLE ${ProductField.productTable} (
          ${ProductField.id} $integer  PRIMARY KEY AUTOINCREMENT,
          ${ProductField.name} $text UNIQUE,
          ${ProductField.qty} $integer,
          ${ProductField.minQty} $integer,
          ${ProductField.date} $text,
          ${ProductField.isTrash} $integer,
          ${ProductField.warehouse} $text
          )''');
        await db.execute('''CREATE TABLE ${BuySellField.buyTable}(
          ${BuySellField.id} $integer PRIMARY KEY AUTOINCREMENT,
          ${BuySellField.productId} $integer,
          ${BuySellField.name} $text,
          ${BuySellField.qty} $integer,
          ${BuySellField.date} $text,
          ${BuySellField.warehouse} $text
          )''');
        await db.execute('''CREATE TABLE ${BuySellField.sellTable}(
          ${BuySellField.id} $integer PRIMARY KEY AUTOINCREMENT,
          ${BuySellField.productId} $integer,
          ${BuySellField.name} $text,
          ${BuySellField.qty} $integer,
          ${BuySellField.date} $text,
          ${BuySellField.warehouse} $text
          )''');

        await db.execute('''CREATE TABLE ${WarehouseField.warehouseTable}(
          ${WarehouseField.id} $integer PRIMARY KEY AUTOINCREMENT,
          ${WarehouseField.name} $text UNIQUE,
          ${WarehouseField.date} $text
          )''');
      },
    );
  }

  ///<<<<<<<<<<<<<<<<For Product>>>>>>>>>>>>>>>>///

  Future<void> createProduct(Product product) async {
    final db = await database;
    await db.insert(
      ProductField.productTable,
      product.toMap(),
    );
  }

  Future<void> trashProduct(Product product) async {
    final db = await database;
    Product trashed = product.copyWith(isTrash: true);
    await db.update(
      ProductField.productTable,
      trashed.toMap(),
      where: "id = ?",
      whereArgs: [product.id],
    );
  }

  Future<void> restoreTrashedProduct(Product product) async {
    final db = await database;
    Product trashed = product.copyWith(isTrash: false);
    await db.update(
      ProductField.productTable,
      trashed.toMap(),
      where: "id = ?",
      whereArgs: [product.id],
    );
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update(
      ProductField.productTable,
      product.toMap(),
      where: "id = ?",
      whereArgs: [product.id],
    );
  }

  Future<List<Product>> getTrashedProducts() async {
    final db = await database;

    final res = await db.query(
      ProductField.productTable,
      where: "is_trash = ? ",
      whereArgs: [1],
      orderBy: "name ASC",
    );

    List<Product> list =
        res.isNotEmpty ? res.map((c) => Product.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Product>> getProductsByWarehouseName(String warehouse) async {
    final db = await database;
    final res = await db.query(
      ProductField.productTable,
      where: "is_trash = ? AND warehouse = ?",
      whereArgs: [0, warehouse],
      orderBy: "name ASC",
    );
    List<Product> list =
        res.isNotEmpty ? res.map((c) => Product.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final res = await db.query(
      ProductField.productTable,
      where: "is_trash = ?",
      whereArgs: [0],
      orderBy: "name ASC",
    );
    List<Product> list =
        res.isNotEmpty ? res.map((c) => Product.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Product>> getProductsUnderMinQty() async {
    final db = await database;
    final res = await db.query(
      ProductField.productTable,
      where: "quantity<min_quantity AND is_trash==0",
      orderBy: "name ASC",
    );
    List<Product> list =
        res.isNotEmpty ? res.map((c) => Product.fromMap(c)).toList() : [];
    return list;
  }

  Future<bool> isProductExist(String name) async {
    Database db = await this.database;
    final count = firstIntValue(
      await db.query(
        ProductField.productTable,
        columns: ['COUNT(*)'],
        where: 'name = ?',
        whereArgs: [name],
      ),
    );
    return (count ?? 0) > 0;
  }

  Future<int> getProductCountByWarehouse(String warehouse) async {
    Database db = await this.database;
    final count = firstIntValue(
      await db.query(
        ProductField.productTable,
        columns: ['COUNT(*)'],
        where: 'warehouse = ?',
        whereArgs: [warehouse],
      ),
    );
    return count ?? 0;
  }

  Future<void> deleteProductById(int id) async {
    final db = await database;
    db.delete(
      ProductField.productTable,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteProductWithGodownName(String warehouse) async {
    final db = await database;
    db.delete(
      ProductField.productTable,
      where: "warehouse = ?",
      whereArgs: [warehouse],
    );
  }

  Future<void> sellProduct(Product product, int sellQty) async {
    final db = await database;
    Product sellproduct =
        product.copyWith(quantity: product.quantity - sellQty);
    await db.update(
      ProductField.productTable,
      sellproduct.toMap(),
      where: "id = ?",
      whereArgs: [product.id],
    );
  }

  Future<void> buyProduct(Product product, int buyQty) async {
    final db = await database;
    Product buyproduct = product.copyWith(quantity: product.quantity + buyQty);
    await db.update(
      ProductField.productTable,
      buyproduct.toMap(),
      where: "id = ?",
      whereArgs: [product.id],
    );
  }

  Future<int> getCountOfProductsUnderMinQty() async {
    Database db = await this.database;
    final count = firstIntValue(
      await db.query(
        ProductField.productTable,
        columns: ['COUNT(*)'],
        where: 'quantity<min_quantity AND is_trash=?',
        whereArgs: [0],
      ),
    );
    return count ?? 0;
  }

  Future<int> getCountOfTrashedProducts() async {
    Database db = await this.database;
    final count = firstIntValue(
      await db.query(
        ProductField.productTable,
        columns: ['COUNT(*)'],
        where: 'is_trash=?',
        whereArgs: [1],
      ),
    );
    return count ?? 0;
  }

  Future<int> getProductCount() async {
    Database db = await this.database;
    final count = firstIntValue(
      await db.query(
        ProductField.productTable,
        columns: ['COUNT(*)'],
        where: 'is_trash=?',
        whereArgs: [0],
      ),
    );
    return count ?? 0;
  }

  Future<void> updateProductByWarehouse({
    required String newWH,
    required String oldWH,
  }) async {
    final db = await database;
    await db.update(
      ProductField.productTable,
      {"warehouse": newWH},
      where: "warehouse= ?",
      whereArgs: [oldWH],
    );
  }

  ///<<<<<<<<<<<for Warehouse>>>>>>>>>///

  Future<void> createWarehouse(Warehouse warehouse) async {
    final db = await database;
    await db.insert(
      WarehouseField.warehouseTable,
      warehouse.toMap(),
    );
  }

  Future<List<Warehouse>> getAllWarehouse() async {
    final db = await database;
    var res = await db.query(WarehouseField.warehouseTable);
    List<Warehouse> list =
        res.isNotEmpty ? res.map((c) => Warehouse.fromMap(c)).toList() : [];
    return list;
  }

  Future<bool> isWarehouseExist(String name) async {
    Database db = await this.database;
    final count = firstIntValue(
      await db.query(
        WarehouseField.warehouseTable,
        columns: ['COUNT(*)'],
        where: 'name = ?',
        whereArgs: [name],
      ),
    );
    return (count ?? 0) > 0;
  }

  Future<void> deleteWarehouse(int id) async {
    final db = await database;
    await db.delete(
      WarehouseField.warehouseTable,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateWarehouse(Warehouse warehouse) async {
    final db = await database;
    await db.update(
      WarehouseField.warehouseTable,
      warehouse.toMap(),
      where: "id = ?",
      whereArgs: [warehouse.id],
    );
  }

  ///<<<<<<<<<<<<<<<<<<<For Sellist>>>>>>>>>>>>>>>>>>>>>>///

  Future<void> createSellProduct(BuySellProduct sellProduct) async {
    final db = await database;
    await db.insert(
      BuySellField.sellTable,
      sellProduct.toMap(),
    );
  }

  Future<List<BuySellProduct>> getAllsellist() async {
    final db = await database;
    final res = await db.query(
      BuySellField.sellTable,
      orderBy: "id DESC",
    );

    List<BuySellProduct> list = res.isNotEmpty
        ? res.map((c) => BuySellProduct.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<List<BuySellProduct>> getSellListByDate(
    String firstDate,
    String secDate,
  ) async {
    final db = await database;
    final res = await db.query(
      BuySellField.sellTable,
      where: 'date>= ? AND date<= ?',
      whereArgs: [firstDate, secDate],
      orderBy: "id DESC",
    );

    List<BuySellProduct> list = res.isNotEmpty
        ? res.map((c) => BuySellProduct.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<void> deleteSellProduct(int id) async {
    final db = await database;
    await db.delete(
      BuySellField.sellTable,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateSellListWithNewWarehouseName(
    String newWarehouse,
    String oldWarehouse,
  ) async {
    final db = await database;
    await db.update(
      BuySellField.sellTable,
      {"warehouse": newWarehouse},
      where: "warehouse= ?",
      whereArgs: [oldWarehouse],
    );
  }

  Future<void> updateSellListWithEditedProduct({
    required String name,
    required String godown,
    required int productId,
  }) async {
    final db = await database;
    await db.update(
      BuySellField.sellTable,
      {"name": name},
      where: "id= ?",
      whereArgs: [productId],
    );
  }

  Future<int> getCountForSellist() async {
    Database db = await this.database;
    final count = firstIntValue(
      await db.query(
        BuySellField.sellTable,
        columns: ['COUNT(*)'],
      ),
    );
    return count ?? 0;
  }

  ///<<<<<<<<<<<<<<<For Buylist>>>>>>>>>>>>>>>>///

  Future<void> createBuyProduct(BuySellProduct buyProduct) async {
    final db = await database;
    await db.insert(
      BuySellField.buyTable,
      buyProduct.toMap(),
    );
  }

  Future<List<BuySellProduct>> getAllbuyList() async {
    final db = await database;
    final res = await db.query(
      BuySellField.buyTable,
      orderBy: "id DESC",
    );
    List<BuySellProduct> list = res.isNotEmpty
        ? res.map((c) => BuySellProduct.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<List<BuySellProduct>> getBuyProductListByDate(
      String firstDate, String secDate) async {
    final db = await database;
    final res = await db.query(
      BuySellField.buyTable,
      where: "date>= ? AND date<= ?",
      whereArgs: [firstDate, secDate],
      orderBy: 'id DESC',
    );
    List<BuySellProduct> list = res.isNotEmpty
        ? res.map((c) => BuySellProduct.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<void> deleteBuylist(int id) async {
    final db = await database;
    await db.delete(
      BuySellField.buyTable,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> updateBuyListWithWarehouseName(
    String newWH,
    String oldWH,
  ) async {
    final db = await database;
    await db.update(
      BuySellField.buyTable,
      {"warehouse": newWH},
      where: "warehouse=?",
      whereArgs: [oldWH],
    );
  }

  Future<void> updateBuyListWithEditedProduct({
    required String name,
    required String godown,
    required int productId,
  }) async {
    final db = await database;
    await db.update(
      BuySellField.buyTable,
      {"name": name},
      where: "id= ?",
      whereArgs: [productId],
    );
  }

  Future<int> getCountForBuyList() async {
    Database db = await this.database;
    final count = firstIntValue(
      await db.query(
        BuySellField.buyTable,
        columns: ['COUNT(*)'],
      ),
    );
    return count ?? 0;
  }
}
