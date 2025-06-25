import 'package:flutter/material.dart';
import 'package:money_app/db/category/category_db.dart';
import 'package:money_app/models/category/category_model.dart';
import 'package:money_app/screens/category/category_add_popup.dart';
import 'package:money_app/screens/category/screen_category.dart';
import 'package:money_app/screens/home/widgets/bottom_navigation.dart';
import 'package:money_app/screens/transactions/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  const ScreenHome({super.key});
  final _pages = const [ScreenTransaction(), ScreenCategory()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MoneyManagerBottomNavigation(),
      appBar: AppBar(title: Text('Money Manager'), centerTitle: true),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: selectedIndexNotifier,
          builder: (BuildContext context, int updatedIndex, _) {
            return _pages[updatedIndex];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            // TODO: Add transaction functionality
          } else {
            showCategoryAddPopup(context);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
