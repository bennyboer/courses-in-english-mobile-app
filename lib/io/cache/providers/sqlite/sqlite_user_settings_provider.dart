import 'dart:async';

import 'package:courses_in_english/io/cache/data_access/databasehelper.dart';
import 'package:courses_in_english/io/cache/providers/user_settings_provider.dart';
import 'package:courses_in_english/model/user/user.dart';
import 'package:courses_in_english/model/user/user_settings.dart';

class SqliteUserSettingsProvider extends CacheUserSettingsProvider {
  final DatabaseHelper dbh;

  SqliteUserSettingsProvider(this.dbh);
  @override
  Future<UserSettings> getCurrentSettings(User user) async {
    List<Map<String, dynamic>> data =
        await dbh.selectWhere("Settings", "userId", 1.toString());
    if (data.isNotEmpty) {
      return new UserSettings(
          feedbackMode: data[0]["feedbackMode"].toLowerCase() == 'true',
          offlineMode: data[0]["offlineMode"].toLowerCase() == 'true');
    } else {
      UserSettings userSettings = new UserSettings();
      putSettings(user, userSettings);
      return userSettings;
    }
  }

  @override
  Future<int> putSettings(User user, UserSettings userSettings) async {
    List<Map<String, dynamic>> userList = [];
    await dbh.deleteWhere("Settings", "userId", 1.toString());
    userList.add(userSettings.toMap());
    return dbh.insertTable("Settings", userList);
    //TODO: WHEN USER LOGS IN NEED TO CREATE USER AND SETTINGS
  }

  @override
  void clearApp() async {
    dbh.truncateAllTable();
  }
}
