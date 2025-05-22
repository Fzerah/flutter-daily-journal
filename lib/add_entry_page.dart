import 'package:flutter/material.dart';
import 'db_helper.dart';

class AddEntryPage extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  AddEntryPage({super.key});

  void _saveEntry(BuildContext context) async {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty || content.isEmpty) return;

    await DBHelper.instance.insertEntry(title, content);
    Navigator.pop(context); // Geri dön
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: _contentController, decoration: const InputDecoration(labelText: 'Content')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => _saveEntry(context), child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
