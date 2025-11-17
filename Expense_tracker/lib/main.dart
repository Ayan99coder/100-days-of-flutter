import 'package:expense_tracker/Screens/Budget_Screen.dart';
import 'package:expense_tracker/Screens/Dashboards_Screens.dart';
import 'package:expense_tracker/Screens/Report_Screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'DataBase/db_helper.dart';
import 'Models/Expense_Model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ExpenseApp());
  }
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const ExpenseHome(),
    );
  }
}

// second
class ExpenseHome extends StatefulWidget {
  const ExpenseHome({super.key});

  @override
  State<ExpenseHome> createState() => _ExpenseHomeState();
}

class _ExpenseHomeState extends State<ExpenseHome> {
  final db = DBHelper.instance;
  List<Expense> items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await db.getAllExpenses();
    setState(() => items = data);
  }

  Future<void> _delete(int id) async {
    await db.deleteExpense(id);
    await _load();
  }

  Future<void> _showAddExpenseForm() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF222222),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: AddExpenseForm(onSave: _load),
      ),
    );
  }

  Future<void> _showTotals() async {
    final totalExpense = await db.getTotalByType('expense');
    final totalIncome = await db.getTotalByType('income');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Totals'),
        content: Text(
          'Expense: \$${totalExpense.toStringAsFixed(2)}\nIncome: \$${totalIncome.toStringAsFixed(2)}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            },
          ),
          SizedBox(width: 5),
          IconButton(icon: const Icon(Icons.pie_chart), onPressed: _showTotals),
          SizedBox(width: 5),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BudgetScreen()),
              );
            },
          ),
          SizedBox(width: 5),
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReportsScreen()),
              );
            },
          ),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: Text('No expenses yet! Tap + to add one.'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) {
                final e = items[i];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  color: Colors.grey.shade900,
                  child: ListTile(
                    leading: Icon(
                      e.type == 'income'
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: e.type == 'income'
                          ? Colors.greenAccent
                          : Colors.redAccent,
                    ),
                    title: Text(
                      '${e.category} - \$${e.amount.toStringAsFixed(2)}',
                    ),
                    subtitle: Text('${e.date} • ${e.notes ?? ''}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _delete(e.id!),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddExpenseForm,
        label: const Text('Add Expense'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

// third
class AddExpenseForm extends StatefulWidget {
  final VoidCallback onSave;

  const AddExpenseForm({super.key, required this.onSave});

  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _selectedCategory = 'Food';
  String _selectedType = 'expense';
  DateTime _selectedDate = DateTime.now();

  final categories = [
    'Food',
    'Transport',
    'Shopping',
    'Bills',
    'Entertainment',
    'Salary',
    'Other',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final newExpense = Expense(
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: DateFormat('yyyy-MM-dd').format(_selectedDate),
        notes: _noteController.text,
        type: _selectedType,
      );

      /// 🔥 INSERT NEW EXPENSE
      await DBHelper.instance.insertExpense(newExpense);

      /// 🔥 TRY UPDATE BUDGET SPENT (SAFE)
      try {
        await DBHelper.instance.updateBudgetSpent(
          newExpense.category,
          newExpense.amount,
        );
      } catch (err) {
        print("Budget update skipped: $err");
      }

      /// 🔥 WAIT for refresh BEFORE closing sheet
       widget.onSave();

      if (!mounted) return;
      Navigator.pop(context);

    } catch (e) {
      print("ERROR INSERTING EXPENSE: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong saving expense!')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Text(
              'Add New Expense',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.attach_money),
              ),
              validator: (v) => v == null || v.isEmpty ? 'Enter amount' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: categories
                  .map(
                    (cats) => DropdownMenuItem(value: cats, child: Text(cats)),
                  )
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
              ),
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                  ),
                ),
                TextButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Pick Date'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Expense'),
                  selected: _selectedType == 'expense',
                  onSelected: (_) => setState(() => _selectedType = 'expense'),
                  selectedColor: Colors.redAccent,
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('Income'),
                  selected: _selectedType == 'income',
                  onSelected: (_) => setState(() => _selectedType = 'income'),
                  selectedColor: Colors.greenAccent,
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                prefixIcon: Icon(Icons.note),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saveExpense,
              icon: const Icon(Icons.save),
              label: const Text('Save Expense'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
