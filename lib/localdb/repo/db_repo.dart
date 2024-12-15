import 'package:isar/isar.dart';

part 'db_repo.g.dart';

@collection
class DbRepo {
  late Id id;
  String? name;
  String? description;
  int? stars;
  int? forks;
  bool? isStarred;
  String? lastUpdated;
}
