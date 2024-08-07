import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_dev_server/data/models/group_apis_model.dart';
import 'package:http_dev_server/data/models/item_api_model.dart';
import 'package:http_dev_server/domain/bloc/apis_bloc/apis_cubit.dart';
import 'package:http_dev_server/feature/apis/widgets/api_create/api_create_dialog.dart';
import 'package:http_dev_server/feature/apis/widgets/api_edit/api_edit_dialog.dart';
import 'package:http_dev_server/feature/apis/widgets/group_create/group_create_dialog.dart';
import 'package:http_dev_server/feature/apis/widgets/group_edit/group_edit_dialog.dart';

class ApisWidget extends StatelessWidget {
  const ApisWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApisCubit, ApisState>(
      buildWhen: (previous, current) => current.isBuild,
      builder: (context, state) {
        if (state is ApisSuccessState) {
          return const SingleChildScrollView(
            child: ApisTreeWidget(),
          );
        }

        return const Center(
          child: Text('Нет данных'),
        );
      },
    );
  }
}

class ApisTreeWidget extends StatefulWidget {
  const ApisTreeWidget({
    super.key,
  });

  @override
  State<ApisTreeWidget> createState() => _ApisTreeWidgetState();
}

class _ApisTreeWidgetState extends State<ApisTreeWidget> {
  @override
  Widget build(BuildContext context) {
    List<GroupApisModel> groups = context.read<ApisCubit>().apis;

    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionPanelList(
          expansionCallback: (index, isExpanded) {
            setState(() {
              groups[index].isExpanded = !groups[index].isExpanded;
            });
          },
          children: groups
              .map(
                (group) => ExpansionPanel(
                  canTapOnHeader: true,
                  backgroundColor: const Color.fromARGB(255, 248, 248, 248),
                  headerBuilder: (context, isExpanded) => Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: Text(
                                  group.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isExpanded)
                        PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (ctx) => [
                            PopupMenuItem(
                              child: const ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Изменить'),
                              ),
                              onTap: () {
                                _openGroupEditDialog(group);
                              },
                            ),
                            PopupMenuItem(
                              child: const ListTile(
                                leading: Icon(Icons.delete, color: Colors.red),
                                title: Text(
                                  'Удалить',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              onTap: () {
                                _deleteGroup(group);
                              },
                            )
                          ],
                        ),
                    ],
                  ),
                  isExpanded: group.isExpanded,
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...group.rows.map(
                        (api) => ListTile(
                          title: Text(api.path, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteApi(group, api);
                            },
                          ),
                          leading: DecoratedBox(
                            decoration: BoxDecoration(
                              color: api.method.color,
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                            ),
                            child: SizedBox(
                              width: 40,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text(
                                  api.method.name,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            _openApiEditDialog(api);
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 6, 0, 10),
                          child: TextButton.icon(
                            onPressed: () {
                              _openApiCreateDialog(group);
                            },
                            label: const Text('Добавить API'),
                            icon: const Icon(Icons.create_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        if (groups.isEmpty) const Text('Добавьте группу, в которой будут содержаться API'),
        Padding(
          padding: EdgeInsets.only(left: 10, top: groups.isNotEmpty ? 20 : 0),
          child: TextButton.icon(
            onPressed: _openGroupCreateDialog,
            label: const Text('Добавить группу'),
            icon: const Icon(Icons.create_new_folder),
          ),
        ),
      ],
    );
  }

  void _openGroupCreateDialog() {
    showDialog<String>(
      context: context,
      builder: (_) => const Dialog(
        child: GroupApiCreateDialog(),
      ),
    ).then(context.read<ApisCubit>().createGroup).then((_) {
      setState(() {});
    });
  }

  void _openGroupEditDialog(GroupApisModel e) {
    showDialog<String>(
      context: context,
      builder: (_) => Dialog(
        child: GroupApiEditDialog(
          groupName: e.name,
        ),
      ),
    ).then((String? newName) {
      return context.read<ApisCubit>().updateGroup(e, newName);
    }).then((_) {
      setState(() {});
    });
  }

  void _deleteGroup(GroupApisModel e) {
    context.read<ApisCubit>().deleteGroup(e).then((_) {
      setState(() {});
    });
  }

  void _openApiCreateDialog(GroupApisModel group) {
    showDialog<ItemApiModel>(
      context: context,
      builder: (_) => const Dialog(
        child: ApiCreateDialog(),
      ),
    ).then((ItemApiModel? changedApi) {
      return context.read<ApisCubit>().createApi(group, changedApi);
    }).then((_) {
      setState(() {});
    });
  }

  void _openApiEditDialog(ItemApiModel api) {
    showDialog<ItemApiModel>(
      context: context,
      builder: (_) => Dialog(
        child: ApiEditDialog(
          apiModel: api,
        ),
      ),
    ).then((ItemApiModel? changedApi) {
      return context.read<ApisCubit>().updateApi(api, changedApi);
    }).then((_) {
      setState(() {});
    });
  }

  void _deleteApi(GroupApisModel group, ItemApiModel api) {
    context.read<ApisCubit>().deleteApi(group, api).then((value) {
      setState(() {});
    });
  }
}
