import 'package:flutter/material.dart';
import 'package:money_app/db/category/category_db.dart';
import 'package:money_app/db/transactions/transaction_db.dart';
import 'package:money_app/models/category/category_model.dart';
import 'package:money_app/models/transactions/transaction_model.dart';

class ScreenAndTransactions extends StatefulWidget {
  static const routeName = 'add-transaction';
  const ScreenAndTransactions({super.key});

  @override
  State<ScreenAndTransactions> createState() => _ScreenAndTransactionsState();
}

class _ScreenAndTransactionsState extends State<ScreenAndTransactions> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;
  String? _categoryID;

  // TextEditingControllers for purpose and amount
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //purpose
              TextFormField(
                controller: _purposeController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(hintText: 'Purpose'),
              ),
              //Amount
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Amount'),
              ),

              //Calender
              TextButton.icon(
                onPressed: () async {
                  var _selectedDateTemp = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (_selectedDateTemp == null) {
                    return;
                  } else {
                    print(_selectedDate.toString());

                    setState(() {
                      _selectedDate = _selectedDateTemp;
                    });
                  }
                },
                icon: Icon(Icons.ac_unit),
                label: Text(
                  _selectedDate == null
                      ? 'Select Date'
                      : _selectedDate.toString(),
                ),
              ),

              //Category
              Row(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.income,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryType = CategoryType.income;
                            _categoryID = null;
                          });
                        },
                      ),
                      Text('Income'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.expense,
                        groupValue: _selectedCategoryType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCategoryType = CategoryType.expense;
                            _categoryID = null;
                          });
                        },
                      ),
                      Text('Expense'),
                    ],
                  ),
                ],
              ),
              //Category Type
              DropdownButton<String>(
                hint: const Text('Select Category'),
                value: _categoryID,
                items:
                    (_selectedCategoryType == CategoryType.income
                            ? CategoryDb().incomeCategoryListListener
                            : CategoryDb().expenseCategoryListListener)
                        .value
                        .map((e) {
                          return DropdownMenuItem(
                            value: e.id,
                            child: Text(e.name),
                            onTap: () {
                              print(e.toString());
                              _selectedCategoryModel = e;
                            },
                          );
                        })
                        .toList(),
                onChanged: (selectedValue) {
                  print(selectedValue);
                  setState(() {
                    _categoryID = selectedValue;
                  });
                },
              ),
              //Submit
              ElevatedButton(
                onPressed: () {
                  addTransaction();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addTransaction() async {
    final _purposeText = _purposeController.text;
    final _amountText = _amountController.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    // if (_categoryID == null) {
    //   return;
    // }
    if (_selectedCategoryModel == null) {
      return;
    }
    if (_selectedDate == null) {
      return;
    }
    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }
    final _model = TransactionModel(
      Purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );
    TransactionDb.instance.addTransaction(_model);
  }
}
