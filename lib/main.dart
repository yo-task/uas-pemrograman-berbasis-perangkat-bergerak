import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'note.dart';
import 'add_note_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Catatan',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Catatan'),
      ),
      body: FutureBuilder<List<Note>>(
        future: _dbHelper.readAllNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final notes = snapshot.data!;
            return ListView.separated(
              itemCount: notes.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final note = notes[index];
                return Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: ListTile(
                    title: Text(note.title),
                    onTap: () => _showActionsModal(note, index),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan saat memuat data'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
          setState(() {}); // Refresh the list after adding or editing a note
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
    );
  }

  void _showActionsModal(Note note, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.visibility),
                title: Text('View'),
                onTap: () {
                  Navigator.pop(context); // Tutup modal saat ini
                  _showNoteDetails(context, note); // Tampilkan detail catatan
                }),
            ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNotePage(note: note)),
                  );
                  setState(() {}); // Refresh UI setelah mengedit catatan
                }),
            ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () async {
                  Navigator.pop(context); // Tutup modal
                  _confirmDelete(note); // Tampilkan dialog konfirmasi
                }),
          ],
        );
      },
    );
  }

  void _showNoteDetails(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note.title),
          content: SingleChildScrollView(
            child: Text(note.content),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(Note note) async {
    final confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Konfirmasi'),
              content: Text('Apakah Anda yakin ingin menghapus catatan ini?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Batal'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text('Hapus'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirm) {
      await _dbHelper.delete(note.id!);
      setState(() {}); // Refresh UI setelah menghapus catatan
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Catatan dihapus')));
    }
  }
}
