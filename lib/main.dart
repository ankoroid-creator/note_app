import 'package:flutter/material.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Заметки',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State createState() => _NotesScreenState();
}

class _NotesScreenState extends State {
  final List _notes = [];

  final TextEditingController _textController = TextEditingController();

  int? _editingIndex;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      if (_editingIndex == null) {
        _notes.add(text);
      } else {
        _notes[_editingIndex!] = text;
        _editingIndex = null;
      }
      _textController.clear();
    });
  }

  void _startEditing(int index) {
    setState(() {
      _editingIndex = index;
      _textController.text = _notes[index];
    });
  }

  void _cancelEditing() {
    setState(() {
      _editingIndex = null;
      _textController.clear();
    });
  }

  void _deleteNote(int index) {
    setState(() {
      if (_editingIndex == index) {
        _editingIndex = null;
        _textController.clear();
      } else if (_editingIndex != null && _editingIndex! > index) {
        _editingIndex = _editingIndex! - 1;
      }
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingIndex != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои Заметки'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: isEditing ? 'Редактировать заметку' : 'Введите текст заметки',
                border: const OutlineInputBorder(),
                suffixIcon: isEditing
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _cancelEditing,
                        tooltip: 'Отмена',
                      )
                    : null,
              ),
              maxLines: null, 
            ),
            const SizedBox(height: 12.0),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveNote,
                icon: Icon(isEditing ? Icons.check : Icons.add),
                label: Text(isEditing ? 'Обновить заметку' : 'Сохранить'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),

            Expanded(
              child: _notes.isEmpty
                  ? const Center(
                      child: Text(
                        'Заметок пока нет',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            title: Text(_notes[index]),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _startEditing(index),
                                  tooltip: 'Редактировать',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteNote(index),
                                  tooltip: 'Удалить',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}