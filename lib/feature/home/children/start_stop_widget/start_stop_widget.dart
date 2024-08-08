import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_dev_server/domain/bloc/apis_bloc/apis_cubit.dart';
import 'package:http_dev_server/domain/bloc/http_server_bloc/http_server_cubit.dart';

class StartStopWidget extends StatefulWidget {
  final bool isPlay;
  final int? port;

  const StartStopWidget({
    super.key,
    required this.isPlay,
    required this.port,
  });

  @override
  State<StartStopWidget> createState() => _StartStopWidgetState();
}

class _StartStopWidgetState extends State<StartStopWidget> {
  final portController = TextEditingController.fromValue(const TextEditingValue(
    text: '8080',
  ));

  @override
  void initState() {
    super.initState();
    if (widget.port != null) portController.text = widget.port.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        SizedBox(
          width: 140,
          child: TextField(
            controller: portController,
            enabled: !widget.isPlay,
            decoration: const InputDecoration(
              prefixText: 'Порт: ',
              border: UnderlineInputBorder(),
              enabledBorder: UnderlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 20),
        if (!widget.isPlay)
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
  }
}
