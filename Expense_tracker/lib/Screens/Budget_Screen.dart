import 'package:flutter/material.dart';
import 'package:expense_tracker/DataBase/db_helper.dart';
import 'package:expense_tracker/Models/Budgets.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final db = DBHelper.instance;
  List<Budget> budgets = [];

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    final list = await db.getAllBudgets();
    setState(() => budgets = list);
  }

  double _progress(double spent, double limitAmount) {
    if (limitAmount == 0) return 0;
    return (spent / limitAmount).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      body: budgets.isEmpty
          ? const Center(child: Text('No budgets added yet'))
          : ListView.builder(
        itemCount: budgets.length,
        itemBuilder: (context, index) {
          final b = budgets[index];
          final progress = _progress(b.spent, b.limitAmount);

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                b.category,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade300,
                    color: progress >= 1
                        ? Colors.red
                        : progress >= 0.8
                        ? Colors.orange
                        : Colors.green,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${b.spent.toStringAsFixed(2)} / ${b.limitAmount.toStringAsFixed(2)}',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
