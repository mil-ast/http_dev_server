import 'dart:convert';

import 'package:http_dev_server/data/models/group_apis_model.dart';
import 'package:http_dev_server/database/database.dart';

abstract interface class IApisDataProvider {
  Future<List<GroupApisModel>> readFromFile();
  Future<void> saveToFile(List<Map<String, Object?>> data);
}

class ApisDataProvider implements IApisDataProvider {
  final IDatabase _db;

  ApisDataProvider({
    required IDatabase db,
  }) : _db = db;

  @override
  Future<List<GroupApisModel>> readFromFile() async {
    final source = await _db.read();
    if (source.isEmpty) {
      return [];
    }
    final json = (jsonDecode(source) as List<dynamic>).cast<Map<String, Object?>>();
    final result = json.map(GroupApisModel.fromJson).toList();

    return result;
  }

  @override
  Future<void> saveToFile(List<Map<String, Object?>> data) async {
    final contents = jsonEncode(data);
    await _db.save(contents);
  }
}
