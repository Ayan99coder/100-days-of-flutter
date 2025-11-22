class NoteModel {
  final int? id;
  final String title;
  final String content;
  final int color;
  final bool isPinned;
  final String date;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.isPinned,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'isPinned': isPinned ? 1 : 0,
      'date': date,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      color: map['color'],
      isPinned: map['isPinned'] == 1,
      date: map['date'],
    );
  }

  // 🔥 Add copyWith to update final fields
  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    int? color,
    bool? isPinned,
    String? date,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      isPinned: isPinned ?? this.isPinned,
      date: date ?? this.date,
    );
  }
}
