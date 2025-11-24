import 'package:flutter/material.dart';
import 'package:theme_color_app/theme.dart';

import 'app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Color Themed App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color successColor =
    isDark ? AppColors.successDark : AppColors.successLight;
    final Color warningColor =
    isDark ? AppColors.warningDark : AppColors.warningLight;
    final Color errorColor =
    isDark ? AppColors.errorDark : AppColors.errorLight;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: colors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Card with secondary color
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Balance: Rs. 20,000',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: colors.secondary,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Accent / tertiary color
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.tertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'This month expenses',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.tertiary,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Status colors from AppColors directly
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatusDot(label: 'Success', color: successColor),
                _StatusDot(label: 'Warning', color: warningColor),
                _StatusDot(label: 'Error', color: errorColor),
              ],
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: colors.secondary,
        label: const Text('Add Expense'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusDot({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}