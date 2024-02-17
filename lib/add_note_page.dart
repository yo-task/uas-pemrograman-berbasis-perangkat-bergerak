import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'note.dart';

class AddNotePage extends StatefulWidget {
  final Note? note; // Tambahkan ini

  AddNotePage({this.note}); // Modifikasi ini

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController =
        TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Tambah Catatan' : 'Edit Catatan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Isi Catatan',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final note = Note(
                  id: widget
                      .note?.id, // Gunakan id yang ada jika dalam mode edit
                  title: _titleController.text,
                  content: _contentController.text,
                );
                if (widget.note == null) {
                  await _dbHelper.create(
                      note); // Tambah catatan baru jika tidak ada note yang diberikan
                } else {
                  await _dbHelper
                      .update(note); // Update catatan jika note diberikan
                }
                Navigator.pop(context);
              },
              child: Text(
                  widget.note == null ? 'Simpan Catatan' : 'Update Catatan'),
              style: ElevatedButton.styleFrom(
                primary: Colors.purple, // Warna tombol
                onPrimary: Colors.white, // Warna teks
              ),
            ),
          ],
        ),
      ),
    );
  }
}
