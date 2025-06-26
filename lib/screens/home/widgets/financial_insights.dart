import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:animate_do/animate_do.dart';
import 'package:money_app/db/transactions/transaction_db.dart';
import 'package:money_app/models/transactions/transaction_model.dart';
import 'package:money_app/models/category/category_model.dart';

class FinancialInsights extends StatelessWidget {
  const FinancialInsights({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: TransactionDb.instance.transactionListNotifier,
      builder: (context, List<TransactionModel> transactions, _) {
        if (transactions.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            // Insights Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Text(
                    'Financial Insights',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.insights_rounded,
                      color: Color(0xFF6366F1),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Chart Card
            FadeInUp(
              duration: const Duration(milliseconds: 600),
              delay: const Duration(milliseconds: 300),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spending by Category',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: _buildPieChart(transactions),
                    ),
                    const SizedBox(height: 16),
                    _buildLegend(transactions),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPieChart(List<TransactionModel> transactions) {
    final expenseTransactions = transactions
        .where((t) => t.type == CategoryType.expense)
        .toList();

    if (expenseTransactions.isEmpty) {
      return const Center(
        child: Text(
          'No expense data available',
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 16,
          ),
        ),
      );
    }

    // Group by category
    final Map<String, double> categoryTotals = {};
    for (var transaction in expenseTransactions) {
      final categoryName = transaction.category.name;
      categoryTotals[categoryName] = 
          (categoryTotals[categoryName] ?? 0) + transaction.amount;
    }

    // Create pie chart sections
    final List<PieChartSectionData> sections = [];
    final colors = [
      const Color(0xFFEF4444),
      const Color(0xFFF97316),
      const Color(0xFFEAB308),
      const Color(0xFF22C55E),
      const Color(0xFF06B6D4),
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
    ];

    int colorIndex = 0;
    categoryTotals.forEach((category, amount) {
      sections.add(
        PieChartSectionData(
          color: colors[colorIndex % colors.length],
          value: amount,
          title: '',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      colorIndex++;
    });

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 2,
        startDegreeOffset: -90,
      ),
    );
  }

  Widget _buildLegend(List<TransactionModel> transactions) {
    final expenseTransactions = transactions
        .where((t) => t.type == CategoryType.expense)
        .toList();

    if (expenseTransactions.isEmpty) {
      return const SizedBox.shrink();
    }

    // Group by category
    final Map<String, double> categoryTotals = {};
    for (var transaction in expenseTransactions) {
      final categoryName = transaction.category.name;
      categoryTotals[categoryName] = 
          (categoryTotals[categoryName] ?? 0) + transaction.amount;
    }

    final colors = [
      const Color(0xFFEF4444),
      const Color(0xFFF97316),
      const Color(0xFFEAB308),
      const Color(0xFF22C55E),
      const Color(0xFF06B6D4),
      const Color(0xFF6366F1),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
    ];

    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: sortedEntries.asMap().entries.map((entry) {
        final index = entry.key;
        final categoryEntry = entry.value;
        final color = colors[index % colors.length];
        
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              categoryEntry.key,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'RS ${categoryEntry.value.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}