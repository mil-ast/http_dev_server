import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_dev_server/data/providers/apis_data_provider.dart';
import 'package:http_dev_server/data/repository/apis_repository.dart';
import 'package:http_dev_server/database/database.dart';
import 'package:http_dev_server/domain/bloc/apis_bloc/apis_cubit.dart';
import 'package:http_dev_server/domain/bloc/http_server_bloc/http_server_cubit.dart';
import 'package:http_dev_server/feature/apis/apis_widget.dart';
import 'package:http_dev_server/feature/home/children/requests_widget/requests_widget.dart';
import 'package:http_dev_server/feature/home/children/start_stop_widget/start_stop_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final db = Database('http_dev_server.json');
            final dataProvider = ApisDataProvider(db: db);
            final repository = ApisRepository(dataProvider: dataProvider);
            return ApisCubit(
              repository: repository,
            )..fetch();
          },
        ),
        BlocProvider(
          create: (context) => HttpServerCubit(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ApisCubit, ApisState>(
            listenWhen: (previous, current) => !current.isBuild,
            listener: (context, state) {
              print(state); // TODO
            },
          ),
          BlocListener<HttpServerCubit, HttpServerState>(
            listenWhen: (previous, current) => !current.isBuild,
            listener: (context, state) {
              if (state is HttpServerErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    content: Text(state.message),
                  ),
                );
              } else if (state is HttpServerInformState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          body: const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: ApisWidget(),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: RequestsWidget(),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: BlocBuilder<HttpServerCubit, HttpServerState>(
            buildWhen: (previous, current) => current is HttpServerInfoState,
            builder: (context, state) {
              state as HttpServerInfoState;

              return StartStopWidget(
                isPlay: state.isPlay,
                port: state.port,
              );
            },
          ),
        ),
      ),
    );
  }
}
