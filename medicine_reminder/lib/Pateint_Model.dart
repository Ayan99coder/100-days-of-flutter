class Medicine {
  int? id;
  String name;
  String dosage;
  String time;
  String note;

  Medicine({
    this.id,
    required this.name,
    required this.dosage,
    required this.time,
    this.note = '',
  });

  // 🔹 Convert Object → Map (for DB insert)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'time': time,
      'note': note,
    };
  }

  // 🔹 Convert Map → Object (for reading)
  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      time: map['time'],
      note: map['note'],
    );
  }
}
