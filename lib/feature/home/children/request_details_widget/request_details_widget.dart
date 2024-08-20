import 'package:flutter/material.dart';
import 'package:http_dev_server/core/theme/theme.dart';
import 'package:http_dev_server/data/models/http_data.dart';
import 'package:http_dev_server/domain/models/request_model.dart';

class RequestDetailsWidget extends StatelessWidget {
  final RequestModel req;

  const RequestDetailsWidget(this.req, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleTextStyle = TextStyle(color: theme.colorScheme.quaternaryColor);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали запроса'),
      ),
      body: SingleChildScrollView(
        child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(
              color: theme.colorScheme.dividerColor,
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
                  child: Text(req.time.toString()),
                ),
              ],
            ),
            if (req.remoteAddress != null)
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
                        Text(req.remoteAddress!.address.toString()),
                        const Text(':'),
                        Text(req.remotePort.toString()),
                        if (req.persistentConnection) ...const [
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
                        req.statusCode.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: MethodType.fromString(req.method).color,
                          borderRadius: const BorderRadius.all(Radius.circular(4)),
                        ),
                        child: SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                            child: Text(
                              req.method,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SelectableText(req.requestedUri.toString()),
                    ],
                  ),
                ),
              ],
            ),
            if (req.headers.isNotEmpty)
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
                        ...req.headers.keys.map(
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
                                      req.headers[key] ?? '',
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
            if (req.content.isNotEmpty)
              TableRow(
                children: [
                  TableCellWidget(
                      child: Text(
                    'Тело запроса',
                    style: titleTextStyle,
                  )),
                  TableCellWidget(
                    child: SelectableText(
                      req.content,
                    ),
                  ),
                ],
              ),
            if (req.responseBody != null && req.responseBody!.isNotEmpty)
              TableRow(
                children: [
                  TableCellWidget(
                      child: Text(
                    'Тело ответа',
                    style: titleTextStyle,
                  )),
                  TableCellWidget(
                    child: SelectableText(
                      req.responseBody!,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
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
