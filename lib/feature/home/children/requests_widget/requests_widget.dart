import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_dev_server/domain/bloc/http_server_bloc/http_server_cubit.dart';
import 'package:http_dev_server/feature/dependencies_scope.dart';
import 'package:http_dev_server/feature/home/children/requests_widget/request_item_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

class RequestsWidget extends StatelessWidget {
  const RequestsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final workDir = DependenciesScope.of(context).workDir;

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
                  Wrap(
                    children: [
                      const Text('Рабочий каталог: '),
                      SelectableText(workDir),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            );
          }
        }

        if (state is HttpServerRequestHistoryState) {
          return ListView.builder(
            itemCount: state.history.length,
            itemBuilder: (context, index) => RequestItemWidget(state.history[index]),
          );
        }

        return const Center(
          child: Text('Ожидается запрос...'),
        );
      },
    );
  }
}
