import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_app/db/transactions/transaction_db.dart';
import 'package:money_app/models/transactions/transaction_model.dart';

class ScreenTransaction extends StatelessWidget {
  const ScreenTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionDb.instance.refresh();
    return ValueListenableBuilder(
      valueListenable: TransactionDb.instance.transactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
        return ListView.separated(
          padding: const EdgeInsets.all(10),

          //Values
          itemBuilder: (context, index) {
            final value = newList[index];
            return Dismissible(
              key: Key(value.id!),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              onDismissed: (direction) {
                TransactionDb.instance.deleteTransaction(value.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Transaction deleted'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        TransactionDb.instance.addTransaction(value);
                      },
                    ),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 50,
                    child: Center(
                      child: Text(
                        DateFormat('dd\nMMM').format(value.date),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  title: Text('RS ${value.amount}'),
                  subtitle: Text(value.category.name),
                  trailing: Text(
                    DateFormat('MMM dd, yyyy').format(value.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10);
          },
          itemCount: newList.length,
        );
      },
    );
  }
}