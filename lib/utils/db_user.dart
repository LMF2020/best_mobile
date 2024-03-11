import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../model/user.dart';

class DBUtil {
  static Database? _sparkDb;
  static DBUtil? _DBUtil;

  String userTable = 't_user';
  String colUUID = 'uuid';
  String colEmail = 'email'; // email
  String colUserId = "id"; // userId
  String colZak = "zak";
  int UUID = 1; // 1表示登录用户的token信息

  DBUtil._createInstance();

  static final DBUtil db = DBUtil._createInstance();

  factory DBUtil() {
    _DBUtil ??= DBUtil._createInstance();
    return _DBUtil!;
  }

  Future<Database> get database async {
    _sparkDb ??= await initializeDatabase();
    return _sparkDb!;
  }

  // 初始化db
  Future<Database> initializeDatabase() async {
    var directory = await getDatabasesPath();
    String path = p.join(directory, 'sparkm.db');
    // print('local storage path $path');

    // if debug env is windows
    if (GetPlatform.isWindows) {
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      var myDatabase = await databaseFactory.openDatabase(path,
          options: OpenDatabaseOptions(
            version: 1,
            onCreate: _createDb,
          ));
      return myDatabase;
    }
    // if debug env is mobile
    var myDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return myDatabase;
  }

  // 创建表
  void _createDb(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $userTable"
        "($colUUID INTEGER PRIMARY KEY, $colEmail TEXT, $colUserId TEXT, $colZak TEXT)");
  }

  // 获取当前登录用户的 access token
  Future<User?> getLoginUser() async {
    final database = await this.database;
    final List<Map<String, dynamic>> results = await database.query(
      userTable,
      columns: [colUserId, colEmail, colZak],
      where: '$colUUID = ?',
      whereArgs: [UUID], // 1 表示access token
    );

    if (results.isNotEmpty) {
      Map<String, dynamic> map = results.first;
      return User.fromMap(map);
    }
    return null;
  }

  // 保存用户，只保存email和id, 因为登录的时候会重新拉取用户信息
  Future<void> saveLoginUser(User user) async {
    // user.createdAt = DateTime.now().millisecondsSinceEpoch;
    final database = await this.database;
    var valmap = {
      colUUID: UUID,
      colUserId: user.id,
      colEmail: user.email,
      colZak: user.zak,
    };
    await database.insert(
      userTable,
      valmap,
      //user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 删除用户
  Future<void> deleteUser() async {
    final database = await this.database;
    await database.delete(
      userTable,
      where: '$colUUID = ?',
      whereArgs: [UUID],
    );
  }

  close() async {
    var db = await database;
    var result = db.close();
    return result;
  }
}
