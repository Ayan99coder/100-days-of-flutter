class Expense {
  int? id;
  double amount;
  String category;
  String date; // store as ISO string yyyy-MM-dd
  String? notes;
  String type; // "expense" or "income"

  Expense({
    this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.notes,
    this.type = 'expense',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date,
      'notes': notes,
      'type': type,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: map['date'] as String,
      notes: map['notes'] as String?,
      type: (map['type'] as String?) ?? 'expense',
    );
  }
}
