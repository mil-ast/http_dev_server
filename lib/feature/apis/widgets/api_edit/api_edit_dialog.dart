import 'package:flutter/material.dart';
import 'package:http_dev_server/core/theme/theme.dart';
import 'package:http_dev_server/data/models/http_data.dart';
import 'package:http_dev_server/data/models/item_api_model.dart';

class ApiEditDialog extends StatefulWidget {
  final ItemApiModel apiModel;

  const ApiEditDialog({
    required this.apiModel,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ApiEditState();
}

class _ApiEditState extends State<ApiEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pathController = TextEditingController();
  final TextEditingController _statusCodeController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  late MethodType _method;
  final List<({String key, String value})> _headers = [];

  @override
  void dispose() {
    _pathController.dispose();
    _statusCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _method = widget.apiModel.method;
    _pathController.text = widget.apiModel.path;
    _statusCodeController.text = widget.apiModel.responseStatusCode.toString();
    _bodyController.text = widget.apiModel.body ?? '';
    if (widget.apiModel.headers != null) {
      _headers.addAll(widget.apiModel.headers!.keys
          .map((k) => (
                key: k,
                value: widget.apiModel.headers![k] ?? '',
              ))
          .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Изменить API'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButton(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        value: widget.apiModel.method,
                        items: MethodType.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.value, style: TextStyle(color: e.color)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          _method = value!;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 6,
                      child: TextFormField(
                        controller: _pathController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          helperText: 'Путь, например, /api/books/search',
                        ),
                        validator: (String? name) {
                          if (name == null || name.isEmpty) {
                            return 'Путь обязателен';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _statusCodeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          helperText: 'Статус код ответа',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Обязательное поле';
                          }
                          final status = int.tryParse(value);
                          if (status == null) {
                            return 'Должно быть числом';
                          }
                          if (status < 100 || status > 599) {
                            return 'Диапазон от 100 до 599';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 6,
                      child: TextFormField(
                        controller: _bodyController,
                        keyboardType: TextInputType.multiline,
                        minLines: 4,
                        maxLines: 8,
                        autocorrect: true,
                        decoration: const InputDecoration(
                          helperText: 'Тело ответа',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (widget.apiModel.headers != null) ...[
                  Text('Заголовки', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 20),
                  ...List.generate(
                      _headers.length,
                      (i) => Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  initialValue: _headers[i].key,
                                  decoration: InputDecoration(
                                    helperText: 'Ключ',
                                    border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Theme.of(context).colorScheme.dividerColor, width: 1.0),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Theme.of(context).colorScheme.dividerColor, width: 1.0),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Обязательное поле';
                                    }
                                    return null;
                                  },
                                  onChanged: (newKey) {
                                    _headers[i] = (key: newKey, value: _headers[i].value);
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 6,
                                child: TextFormField(
                                  initialValue: _headers[i].value,
                                  autocorrect: true,
                                  decoration: InputDecoration(
                                    helperText: 'Значение',
                                    border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Theme.of(context).colorScheme.dividerColor, width: 1.0),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Theme.of(context).colorScheme.dividerColor, width: 1.0),
                                    ),
                                  ),
                                  onChanged: (newValue) {
                                    _headers[i] = (key: _headers[i].key, value: newValue);
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _headers.removeAt(i);
                                  });
                                },
                                color: Theme.of(context).colorScheme.error,
                                icon: const Icon(
                                  Icons.delete_outline,
                                ),
                              ),
                            ],
                          )),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _headers.add((key: '', value: ''));
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Добавить заголовок'),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: Navigator.of(context).pop,
                      child: const Text('Закрыть'),
                    ),
                    const SizedBox(width: 20),
                    FilledButton(
                      child: const Text('Сохранить'),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Проверьте правильность заполнения формы'),
                            ),
                          );
                          return;
                        }

                        _headers.removeWhere((v) => v.key.isEmpty);

                        final newApiModel = ItemApiModel(
                          method: _method,
                          path: _pathController.text,
                          responseStatusCode: int.parse(_statusCodeController.text),
                          body: _bodyController.text,
                          headers: {for (var v in _headers) v.key: v.value},
                        );
                        Navigator.of(context).pop(newApiModel);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
