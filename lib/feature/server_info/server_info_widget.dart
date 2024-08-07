import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_dev_server/core/theme/theme.dart';
import 'package:http_dev_server/data/models/http_data.dart';
import 'package:http_dev_server/domain/bloc/http_server_bloc/http_server_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ServerInfoWidget extends StatelessWidget {
  const ServerInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HttpServerCubit, HttpServerState>(
      buildWhen: (previous, current) => current.isBuild,
      builder: (context, state) {
        if (state is HttpServerInfoState) {
          if (!state.isPlay) {
            return Center(
              child: Column(
                children: [
                  const Spacer(),
                  const Text('Сервер остановлен'),
                  FutureBuilder(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.done && snap.hasData) {
                        return Text('v${snap.data?.version}');
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const Spacer(),
                ],
              ),
            );
          }
        }
        if (state is HttpServerRequestState) {
          final titleTextStyle = TextStyle(color: Theme.of(context).colorScheme.quaternaryColor);
          return SingleChildScrollView(
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: Theme.of(context).colorScheme.dividerColor,
                  width: 1,
                ),
              ),
              defaultVerticalAlignment: TableCellVerticalAlignment.top,
              columnWidths: const {
                0: FixedColumnWidth(140.0),
              },
              children: [
                TableRow(
                  children: [
                    TableCellWidget(
                        child: Text(
                      'Время запроса',
                      style: titleTextStyle,
                    )),
                    TableCellWidget(
                      child: Text(DateTime.now().toString()),
                    ),
                  ],
                ),
                if (state.remoteAddress != null)
                  TableRow(
                    children: [
                      TableCellWidget(
                          child: Text(
                        'Клиент',
                        style: titleTextStyle,
                      )),
                      TableCellWidget(
                        child: Wrap(
                          children: [
                            Text(state.remoteAddress!.address.toString()),
                            const Text(':'),
                            Text(state.remotePort.toString()),
                            if (state.persistentConnection) ...const [
                              SizedBox(width: 10),
                              Text('Persistent connection', style: TextStyle(color: Colors.green))
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                TableRow(
                  children: [
                    TableCellWidget(
                        child: Text(
                      'АПИ',
                      style: titleTextStyle,
                    )),
                    TableCellWidget(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: [
                          Text(
                            state.statusCode.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: MethodType.fromString(state.method).color,
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                            ),
                            child: SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                                child: Text(
                                  state.method,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          SelectableText(state.requestedUri.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
                if (state.headers.isNotEmpty)
                  TableRow(
                    children: [
                      TableCellWidget(
                          child: Text(
                        'Заголовки',
                        style: titleTextStyle,
                      )),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 14),
                        child: Column(
                          children: [
                            ...state.headers.keys.map(
                              (key) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: SelectableText(
                                          key,
                                          style: titleTextStyle,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: SelectableText(
                                          state.headers[key] ?? '',
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (state.content.isNotEmpty)
                  TableRow(
                    children: [
                      TableCellWidget(
                          child: Text(
                        'Тело запроса',
                        style: titleTextStyle,
                      )),
                      TableCellWidget(
                        child: SelectableText(
                          state.content,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        }

        return const Center(
          child: Text('Ожидается запрос...'),
        );
      },
    );
  }
}

class TableCellWidget extends StatelessWidget {
  final Widget child;
  const TableCellWidget({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: child,
      ),
    );
  }
}
