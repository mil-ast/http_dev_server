import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_dev_server/data/models/group_apis_model.dart';
import 'package:http_dev_server/data/models/item_api_model.dart';
import 'package:http_dev_server/data/repository/apis_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part './apis_states.dart';

class ApisCubit extends Cubit<ApisState> {
  static const spKeyWorkDir = 'work_dir';
  final IApisRepository _repository;
  final List<GroupApisModel> _apis = [];

  ApisCubit({
    required IApisRepository repository,
  })  : _repository = repository,
        super(ApisState.ready());

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    emit(ApisState.failure(error));
  }

  List<GroupApisModel> get apis => _apis;

  Future<void> fetch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? workDir = prefs.getString(spKeyWorkDir);
      if (workDir == null) {
        final Directory appSupportDir = await getApplicationSupportDirectory();
        workDir = appSupportDir.path;
      }

      _apis.clear();
      final data = await _repository.readFromFile();

      _apis.addAll(data);
      if (_apis.length == 1) {
        _apis.first.isExpanded = true;
      }

      emit(ApisState.success(data));
    } catch (e, st) {
      onError(e, st);
    }
  }

  Future<void> createGroup(String? newGroupName) async {
    try {
      if (newGroupName == null || newGroupName.isEmpty) {
        return;
      }
      final defaultApis = <ItemApiModel>[];
      if (_apis.isEmpty) {
        defaultApis.add(ItemApiModel.withDefaultValues());
      }
      final newGroup = GroupApisModel(
        newGroupName,
        defaultApis,
        isExpanded: true,
      );
      _apis.add(newGroup);

      await _saveFile();
    } catch (e, st) {
      onError(e, st);
    }
  }

  Future<void> updateGroup(GroupApisModel group, String? newName) async {
    if (newName == null || group.name == newName) {
      return;
    }

    try {
      group.name = newName;
      await _saveFile();
    } catch (e, st) {
      onError(e, st);
    }
  }

  Future<void> deleteGroup(GroupApisModel group) async {
    _apis.remove(group);
    await _saveFile();
  }

  Future<void> createApi(GroupApisModel group, ItemApiModel? newApi) async {
    try {
      if (newApi == null) {
        return;
      }

      group.rows.add(newApi);
      await _saveFile();
    } catch (e, st) {
      onError(e, st);
    }
  }

  Future<void> updateApi(ItemApiModel api, ItemApiModel? changedApi) async {
    try {
      if (changedApi == null) {
        return;
      }
      final index = _apis.indexWhere(
        (group) {
          for (final api in group.rows) {
            if (api.key != changedApi.key && api.method == changedApi.method && api.path == changedApi.path) {
              return true;
            }
          }
          return false;
        },
      );
      if (index != -1) {
        throw Exception('Апи уже существует ${changedApi.method} ${changedApi.path}');
      }

      api.method = changedApi.method;
      api.path = changedApi.path;
      api.responseStatusCode = changedApi.responseStatusCode;
      api.body = changedApi.body;
      api.headers = changedApi.headers;
      await _saveFile();
    } catch (e, st) {
      onError(e, st);
    }
  }

  Future<void> deleteApi(GroupApisModel group, ItemApiModel api) async {
    try {
      if (group.rows.remove(api)) {
        await _saveFile();
      }
    } catch (e, st) {
      onError(e, st);
    }
  }

  Map<String, ItemApiModel> apisToMap() {
    final Map<String, ItemApiModel> m = {};
    for (int i = 0; i < _apis.length; i++) {
      final groupApis = {for (var v in _apis[i].rows) v.key: v};
      m.addAll(groupApis);
    }
    return m;
  }

  Future<void> _saveFile() async {
    final json = _apis.map(
      (e) => e.toJson(),
    );
    await _repository.saveToFile(json.toList());
  }
}
