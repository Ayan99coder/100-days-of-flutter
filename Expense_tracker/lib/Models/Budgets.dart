class Budget {
  final int? id;
  final String category;
  final double limitAmount;
  final double spent;

  Budget({
    this.id,
    required this.category,
    required this.limitAmount,
    required this.spent,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'limitAmount': limitAmount,
      'spent': spent,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      category: map['category'],
      limitAmount: map['limitAmount'],
      spent: map['spent'],
    );
  }
}
