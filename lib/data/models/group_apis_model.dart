import 'package:http_dev_server/data/models/item_api_model.dart';

class GroupApisModel {
  String name;
  bool isExpanded = false;

  List<ItemApiModel> rows;

  GroupApisModel(this.name, this.rows, {this.isExpanded = false});

  factory GroupApisModel.fromJson(Map<String, Object?> json) {
    final rows = (json['apis'] as List<dynamic>).cast<Map<String, Object?>>();
    final apisList = rows.map(ItemApiModel.fromJson);
    return GroupApisModel(
      (json['group_name'] as String?) ?? 'Undefined group',
      apisList.toList(),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'group_name': name,
      'apis': rows.map((e) => e.toJson()).toList(),
    };
  }
}
