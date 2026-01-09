class NoteModel {
  final int? id;
  final String title;
  final String content;
  final int color;
  final bool isPinned;
  final String date;
  final bool isArchived;
  final bool isTrashed;
  final DateTime? trashDate;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.isPinned,
    required this.date,
    required this.isArchived,
    required this.isTrashed,
    this.trashDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'isPinned': isPinned ? 1 : 0,
      'isArchived': isArchived ? 1 : 0,
      'isTrashed': isTrashed ? 1 : 0,
      'date': date,
      'trashDate': trashDate?.toIso8601String(),
    };
  }


  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      color: map['color'],
      isPinned: map['isPinned'] == 1,
      isArchived: map['isArchived'] == 1,
      isTrashed: map['isTrashed'] == 1,
      date: map['date'],
      trashDate: map['trashDate'] != null
          ? DateTime.parse(map['trashDate'])
          : null,
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
    bool? isArchived,
    bool? isTrashed,
    DateTime? trashDate,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      isPinned: isPinned ?? this.isPinned,
      date: date ?? this.date,
      isArchived: isArchived ?? this.isArchived,
      isTrashed: isTrashed ?? this.isTrashed,
      trashDate: trashDate ?? this.trashDate,
    );
  }
}
