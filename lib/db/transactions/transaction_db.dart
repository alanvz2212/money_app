import 'package:hive_flutter/adapters.dart';
import 'package:money_app/models/transactions/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transaction-db';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactionModel obj);
}

class TransactionDb implements TransactionDbFunctions {
  TransactionDb._internal();
  static TransactionDb instance = TransactionDb._internal();

  factory TransactionDb() {
    return instance;
  }

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await _db.put(obj.id, obj);
  }
}
