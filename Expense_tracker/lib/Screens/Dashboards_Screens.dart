import 'package:expense_tracker/DataBase/db_helper.dart';
import 'package:expense_tracker/Models/Expense_Model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final db = DBHelper.instance;
  double totalIncome = 0;
  double totalExpense = 0;
  List<Expense> allExpenses = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await db.getAllExpenses();
    final income = await db.getTotalByType('income');
    final expense = await db.getTotalByType('expense');

    setState(() {
      allExpenses = data;
      totalIncome = income;
      totalExpense = expense;
    });
  }

  Map<String, double> _categoryTotals() {
    final Map<String, double> map = {};
    for (var e in allExpenses.where((x) => x.type == 'expense')) {
      map[e.category] = (map[e.category] ?? 0) + e.amount;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final balance = totalIncome - totalExpense;
    final categories = _categoryTotals();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 💰 Totals Card
            Card(
              color: Colors.grey.shade900,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Income', style: TextStyle(color: Colors.greenAccent)),
                            Text('\$${totalIncome.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Expense', style: TextStyle(color: Colors.redAccent)),
                            Text('\$${totalExpense.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Balance', style: TextStyle(color: Colors.blueAccent)),
                            Text('\$${balance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 📈 Weekly Trend (Dummy Data Example)
            const Text('Weekly Spending Trend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      spots: [
                        FlSpot(0, 30),
                        FlSpot(1, 50),
                        FlSpot(2, 40),
                        FlSpot(3, 60),
                        FlSpot(4, 45),
                        FlSpot(5, 70),
                        FlSpot(6, 65),
                      ],
                      barWidth: 3,
                      color: Colors.tealAccent,
                      belowBarData: BarAreaData(show: true, color: Colors.tealAccent.withOpacity(0.2)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🥧 Pie Chart for categories
            const Text('Spending by Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            categories.isEmpty
                ? const Text('No data yet!')
                : SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: categories.entries.map((e) {
                    final value = e.value;
                    final percent = (value / totalExpense * 100);
                    return PieChartSectionData(
                      color: Colors.primaries[categories.keys.toList().indexOf(e.key) % Colors.primaries.length],
                      value: value,
                      title: '${e.key}\n${percent.toStringAsFixed(1)}%',
                      radius: 60,
                      titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 📊 Bar Chart for monthly summary
            const Text('Monthly Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(toY: 3, width: 12),
                      BarChartRodData(toY: 5, width: 12, color: Colors.greenAccent),
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(toY: 2, width: 12),
                      BarChartRodData(toY: 4, width: 12, color: Colors.greenAccent),
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(toY: 4, width: 12),
                      BarChartRodData(toY: 6, width: 12, color: Colors.greenAccent),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
