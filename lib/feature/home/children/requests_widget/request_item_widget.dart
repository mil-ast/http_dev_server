import 'package:flutter/material.dart';
import 'package:http_dev_server/core/extensions/date_format_extension.dart';
import 'package:http_dev_server/data/models/http_data.dart';
import 'package:http_dev_server/domain/models/request_model.dart';
import 'package:http_dev_server/feature/home/children/request_details_widget/request_details_widget.dart';

class RequestItemWidget extends StatelessWidget {
  final RequestModel req;
  const RequestItemWidget(this.req, {super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      titleTextStyle: textTheme.bodyMedium,
      leading: Wrap(
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(req.time.hms()),
          Text(req.statusCode.toString(), style: textTheme.titleSmall),
          SizedBox(
            width: 60,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: MethodType.fromString(req.method).color,
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                child: Text(
                  req.method,
                  textAlign: TextAlign.center,
                  style: textTheme.labelSmall,
                ),
              ),
            ),
          ),
        ],
      ),
      title: Text(req.requestedUri.toString()),
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (_) => Dialog(
            child: RequestDetailsWidget(
              req,
            ),
          ),
        );
      },
    );
  }
}
