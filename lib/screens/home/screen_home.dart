import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:money_app/screens/add_transactions/screen_and_transactions.dart';
import 'package:money_app/screens/category/category_add_popup.dart';
import 'package:money_app/screens/category/screen_category.dart';
import 'package:money_app/screens/home/widgets/bottom_navigation.dart';
import 'package:money_app/screens/home/widgets/financial_insights.dart';
import 'package:money_app/db/transactions/transaction_db.dart';
import 'package:money_app/models/transactions/transaction_model.dart';
import 'package:money_app/models/category/category_model.dart';

class ScreenHome extends StatelessWidget {
  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [_buildTransactionsPage(context), const ScreenCategory()];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar with Balance Summary
            FadeInDown(
              duration: const Duration(milliseconds: 800),
              child: _buildCustomAppBar(context),
            ),

            // Page Content
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: selectedIndexNotifier,
                builder: (BuildContext context, int updatedIndex, _) {
                  return FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 200),
                    child: pages[updatedIndex],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SlideInUp(
        duration: const Duration(milliseconds: 800),
        delay: const Duration(milliseconds: 400),
        child: MoneyManagerBottomNavigation(),
      ),
      floatingActionButton: ZoomIn(
        duration: const Duration(milliseconds: 600),
        delay: const Duration(milliseconds: 600),
        child: _buildFloatingActionButton(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA855F7)],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Money Manager',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Balance Summary Card
              _buildBalanceSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceSummary() {
    return ValueListenableBuilder(
      valueListenable: TransactionDb.instance.transactionListNotifier,
      builder: (context, List<TransactionModel> transactions, _) {
        double totalIncome = 0;
        double totalExpense = 0;

        for (var transaction in transactions) {
          if (transaction.type == CategoryType.income) {
            totalIncome += transaction.amount;
          } else {
            totalExpense += transaction.amount;
          }
        }

        double balance = totalIncome - totalExpense;

        return Container(
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
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Total Balance',
                style: TextStyle(
                  color: const Color(0xFF64748B),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'RS ${balance.toStringAsFixed(2)}',
                style: TextStyle(
                  color: balance >= 0
                      ? const Color(0xFF059669)
                      : const Color(0xFFDC2626),
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryItem(
                      'Income',
                      totalIncome,
                      const Color(0xFF059669),
                      Icons.trending_up_rounded,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFE2E8F0).withOpacity(0.3),
                          const Color(0xFFE2E8F0),
                          const Color(0xFFE2E8F0).withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildSummaryItem(
                      'Expense',
                      totalExpense,
                      const Color(0xFFDC2626),
                      Icons.trending_down_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(
    String title,
    double amount,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF64748B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'RS ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsPage(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Financial Insights
        SliverToBoxAdapter(
          child: Column(
            children: [
              const FinancialInsights(),
              const SizedBox(height: 16),
              // Quick Actions Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      'Recent Transactions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF6366F1).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: const Color(0xFF6366F1),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Transactions List as Sliver
        ValueListenableBuilder(
          valueListenable: TransactionDb.instance.transactionListNotifier,
          builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
            if (newList.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            ),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: const Icon(
                            Icons.receipt_long_rounded,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'No Transactions Yet',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Start by adding your first transaction',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.only(bottom: 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final value = newList[index];
                  final isIncome = value.type == CategoryType.income;
                  final transactionColor = isIncome
                      ? const Color(0xFF059669)
                      : const Color(0xFFDC2626);

                  return Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: index == 0 ? 8 : 4,
                      bottom: 4,
                    ),
                    child: FadeInUp(
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      child: Dismissible(
                        key: Key(value.id!),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onDismissed: (direction) {
                          TransactionDb.instance.deleteTransaction(value.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Transaction deleted'),
                              backgroundColor: const Color(0xFF1E293B),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              action: SnackBarAction(
                                label: 'UNDO',
                                textColor: const Color(0xFF6366F1),
                                onPressed: () {
                                  TransactionDb.instance.addTransaction(value);
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                // Date Circle
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        transactionColor.withOpacity(0.1),
                                        transactionColor.withOpacity(0.05),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: transactionColor.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat('dd').format(value.date),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: transactionColor,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('MMM').format(value.date),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: transactionColor.withOpacity(
                                            0.7,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // Transaction Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: transactionColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              value.category.name,
                                              style: TextStyle(
                                                color: transactionColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        value.purpose,
                                        style: const TextStyle(
                                          color: Color(0xFF1E293B),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat(
                                          'EEEE, MMM dd, yyyy',
                                        ).format(value.date),
                                        style: const TextStyle(
                                          color: Color(0xFF64748B),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Amount and Icon
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: transactionColor.withOpacity(
                                          0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        isIncome
                                            ? Icons.trending_up_rounded
                                            : Icons.trending_down_rounded,
                                        color: transactionColor,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${isIncome ? '+' : '-'} RS ${value.amount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: transactionColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }, childCount: newList.length),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedIndexNotifier,
      builder: (context, int selectedIndex, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.2),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              if (selectedIndex == 0) {
                Navigator.of(
                  context,
                ).pushNamed(ScreenAndTransactions.routeName);
              } else {
                showCategoryAddPopup(context);
              }
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Icon(
              selectedIndex == 0 ? Icons.add_rounded : Icons.category_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        );
      },
    );
  }
}
