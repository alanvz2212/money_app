import 'package:flutter/material.dart';

class ExpenseCategory extends StatelessWidget {
  const ExpenseCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text('Expense Category $index'),
            trailing: IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
      itemCount: 100,
    );
  }
}
