import 'package:expense_tracker/DataBase/db_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final db = DBHelper.instance;
  Map<String, double> categoryTotals = {};
  double totalExpense = 0;
  Map<String, double> monthlyExpenses = {};

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final expenses = await db.getAllExpenses();
    final monthly = await db.getMonthlyExpenses();

    // Category totals
    final Map<String, double> totals = {};
    double total = 0;
    for (var e in expenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
      total += e.amount;
    }

    setState(() {
      categoryTotals = totals;
      totalExpense = total;
      monthlyExpenses = monthly;
    });
  }

  List<PieChartSectionData> _buildPieSections() {
    return categoryTotals.entries.map((entry) {
      final percentage = (entry.value / totalExpense) * 100;
      return PieChartSectionData(
        value: entry.value,
        color: _getRandomColor(entry.key),
        title: '${entry.key}\n${percentage.toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
    }).toList();
  }

  Color _getRandomColor(String category) {
    final colors = [
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
      Colors.pinkAccent,
      Colors.redAccent,
      Colors.tealAccent,
    ];
    return colors[category.hashCode % colors.length];
  }

  List<BarChartGroupData> _buildBarGroups() {
    int index = 0;
    return monthlyExpenses.entries.map((entry) {
      index++;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: Colors.greenAccent,
            width: 14,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final months = monthlyExpenses.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Reports & Charts')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: (categoryTotals.isEmpty && monthlyExpenses.isEmpty)
            ? const Center(child: Text('No data yet'))
            : SingleChildScrollView(
          child: Column(
            children: [
              // 🥧 Pie Chart
              const Text(
                'Category-wise Spending',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections: _buildPieSections(),
                    centerSpaceRadius: 40,
                    sectionsSpace: 4,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // 📊 Bar Chart
              const Text(
                'Monthly Expense Trend',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    barGroups: _buildBarGroups(),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            int i = value.toInt() - 1;
                            if (i >= 0 && i < months.length) {
                              return Text(
                                months[i].split('-')[1], // only show month part
                                style: const TextStyle(fontSize: 10),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
