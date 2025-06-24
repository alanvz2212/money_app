import 'package:hive/hive.dart';
import 'package:money_app/models/category/category_model.dart';

const categoryDbName = "category_db";

abstract class CatergoryDbFunctions {
  Future<List<CategoryModel>> getCatgories();
  Future<void> insertCategory(CategoryModel value);
}

class CategoryDb implements CatergoryDbFunctions {
  @override
  Future<void> insertCategory(CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    await categoryDB.add(value);
  }

  @override
  Future<List<CategoryModel>> getCatgories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    return categoryDB.values.toList();
  }
}
