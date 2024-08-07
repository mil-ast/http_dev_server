import 'package:http_dev_server/data/models/group_apis_model.dart';
import 'package:http_dev_server/data/providers/apis_data_provider.dart';

abstract interface class IApisRepository {
  Future<List<GroupApisModel>> readFromFile();
  Future<void> saveToFile(List<Map<String, Object?>> data);
}

class ApisRepository implements IApisRepository {
  final IApisDataProvider _dataProvider;

  ApisRepository({
    required IApisDataProvider dataProvider,
  }) : _dataProvider = dataProvider;

  @override
  Future<List<GroupApisModel>> readFromFile() {
    return _dataProvider.readFromFile();
  }

  @override
  Future<void> saveToFile(List<Map<String, Object?>> data) {
    return _dataProvider.saveToFile(data);
  }
}
