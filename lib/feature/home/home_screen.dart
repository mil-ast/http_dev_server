import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_dev_server/domain/bloc/apis_bloc/apis_cubit.dart';
import 'package:http_dev_server/domain/bloc/http_server_bloc/http_server_cubit.dart';
import 'package:http_dev_server/feature/apis/apis_widget.dart';
import 'package:http_dev_server/feature/dependencies_scope.dart';
import 'package:http_dev_server/feature/home/children/requests_widget/requests_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = DependenciesScope.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return ApisCubit(
              repository: dependencies.apisRepository,
            )..fetch();
          },
        ),
        BlocProvider(
          create: (context) => HttpServerCubit(
            sp: dependencies.sp,
          ),
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
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('HTTP Dev server'),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
          ),
          drawer: Drawer(
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: const ApisWidget(),
          ),
          body: const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
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

              final portController = TextEditingController(text: '${state.port}');
              return Row(
                children: [
                  const Spacer(),
                  if (state.isPlay)
                    TextButton.icon(
                      onPressed: () {
                        context.read<HttpServerCubit>().clearHistory();
                      },
                      label: const Text('Очистить'),
                      icon: const Icon(Icons.clear_all_outlined),
                    ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 140,
                    child: TextField(
                      controller: portController,
                      enabled: !state.isPlay,
                      decoration: const InputDecoration(
                        prefixText: 'Порт: ',
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 20),
                  if (!state.isPlay)
                    FloatingActionButton(
                      onPressed: () {
                        final apis = context.read<ApisCubit>().apis;
                        context.read<HttpServerCubit>().start(apis, int.tryParse(portController.text));
                      },
                      tooltip: 'Запустить сервер',
                      child: const Icon(Icons.play_arrow),
                    )
                  else
                    FloatingActionButton(
                      onPressed: context.read<HttpServerCubit>().stop,
                      backgroundColor: Theme.of(context).colorScheme.error,
                      tooltip: 'Остановить сервер',
                      child: const Icon(Icons.stop_outlined),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
