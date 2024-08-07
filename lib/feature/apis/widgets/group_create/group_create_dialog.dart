import 'package:flutter/material.dart';

class GroupApiCreateDialog extends StatefulWidget {
  const GroupApiCreateDialog({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _GroupApiEditState();
}

class _GroupApiEditState extends State<GroupApiCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать новую группу'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  helperText: 'Название группы',
                  icon: Icon(Icons.title),
                ),
                validator: (String? name) {
                  if (name == null || name.isEmpty) {
                    return 'Название слишком короткое';
                  } else if (name.length > 100) {
                    return 'Название слишком длинное';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text('Отмена'),
                  ),
                  const SizedBox(width: 20),
                  FilledButton(
                    child: const Text('Добавить'),
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Проверьте правильность заполнения формы'),
                          ),
                        );
                        return;
                      }
                      Navigator.of(context).pop(_nameController.text);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
