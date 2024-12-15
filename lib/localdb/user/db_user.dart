import 'package:isar/isar.dart';

part 'db_user.g.dart';

@collection
class DbUser {
  Id id = Isar.autoIncrement;
  late int userId;
  String? login;
  String? avatarUrl;
  String? accessToken;
  String? email;
  String? name;
}
