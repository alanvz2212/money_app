import 'package:flutter/material.dart';

class IncomeCategory extends StatelessWidget {
  const IncomeCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text('Income Category $index'),
            trailing: IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 10);
      },
      itemCount: 100,
    );
  }
}
