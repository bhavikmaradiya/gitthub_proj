import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/preference_config.dart';
import '../utils/static_functions.dart';
import 'repo/db_repo.dart';
import 'user/db_user.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<void> saveOrUpdateUserInfo(DbUser userInfo) async {
    final isar = await db;
    await isar.writeTxn(
      () async {
        await isar.dbUsers.put(userInfo);
        StaticFunctions.userInfo = userInfo;
      },
    );
  }

  Future<DbUser?> getUserInfo() async {
    final preferences = await SharedPreferences.getInstance();
    final userId = preferences.getInt(PreferenceConfig.userIdPref);
    if (userId == null) {
      return null;
    }
    final isar = await db;
    return await isar.dbUsers.filter().userIdEqualTo(userId).findFirst();
  }

  Future<void> updateRepoInfo(
    List<DbRepo> repos,
  ) async {
    final isar = await db;
    await isar.writeTxn(
      () async {
        await isar.dbRepos.putAll(repos);
      },
    );
  }

  Future<List<DbRepo>> getAllRepos() async {
    final isar = await db;
    return await isar.dbRepos.where().findAll();
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final directory = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [
          DbUserSchema,
          DbRepoSchema,
        ],
        directory: directory.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }
}
