import 'package:flutter/material.dart';
import 'package:hotel3/src/models/category.dart';
import 'package:hotel3/src/models/response_api.dart';
import 'package:hotel3/src/models/user.dart';
import 'package:hotel3/src/provider/categories_provider.dart';
import 'package:hotel3/src/utils/my_snackbar.dart';
import 'package:hotel3/src/utils/shared_pref.dart';



class RestaurantCategoriesCreateController {

  BuildContext context;
  Function refresh;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final CategoriesProvider _categoriesProvider = CategoriesProvider();
  User user;
  SharedPref sharedPref = SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user =User.fromJson(await sharedPref.read('user'));
    _categoriesProvider.init(context, user);
  }

  void createCategory() async {
    String name = nameController.text;
    String description = descriptionController.text;

    if (name.isEmpty || description.isEmpty) {
      MySnackbar.show(context, 'Debe ingresar todos los campos');
      return;
    }

    Category category = Category(
      name: name,
      description: description
    );

    ResponseApi responseApi = await _categoriesProvider.create(category);

    MySnackbar.show(context, responseApi.message);

    if (responseApi.success) {
      nameController.text = '';
      descriptionController.text = '';
    }

  }

}