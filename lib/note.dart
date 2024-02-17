class Note {
  int? id;
  String title;
  String content;

  Note({
    this.id,
    required this.title,
    required this.content,
  });

  // Konversi objek Note menjadi Map. Berguna untuk penyimpanan ke database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }

  // Membuat objek Note baru dari Map. Berguna saat membaca data dari database.
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }

  // Fungsi bantuan untuk membuat salinan objek Note dengan properti yang mungkin diubah
  Note copy({
    int? id,
    String? title,
    String? content,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
