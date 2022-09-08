import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hotel3/src/models/category.dart';
import 'package:hotel3/src/models/product.dart';
import 'package:hotel3/src/models/user.dart';
import 'package:hotel3/src/pages/client/products/detail/client_products_detail_page.dart';
import 'package:hotel3/src/provider/categories_provider.dart';
import 'package:hotel3/src/provider/products_provider.dart';
import 'package:hotel3/src/utils/shared_pref.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class ClientProductsListController {

  BuildContext context;
  final SharedPref _sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  Function refresh;
  User user;
  final CategoriesProvider _categoriesProvider = CategoriesProvider();
  final ProductsProvider _productsProvider = ProductsProvider();
  List<Category> categories = [];

  Timer searchOnStoppedTyping;
  String productName = '';

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    _categoriesProvider.init(context, user);
    _productsProvider.init(context, user);
    getCategories();
    refresh();
  }

  void onChangeText (String text) {
    Duration duration = const Duration(milliseconds: 800);

    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping.cancel();
      refresh();
    }

    searchOnStoppedTyping = Timer(duration, () {
      productName = text;

      refresh();
      print('TEXTO COMPLETO: $productName');
    });
  }

  Future<List<Product>> getProducts(String idCategory, String productName) async {

    if (productName.isEmpty) {
      return await _productsProvider.getByCategory(idCategory);
    }
    else {
      return await _productsProvider.getByCategoryAndProductName(idCategory, productName);

    }

  }

  void getCategories() async {
    categories = await _categoriesProvider.getAll();
    refresh();
  }

  void openBottomSheet(Product product) {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClientsProductsDetailPage(product: product,)
    );
  }

  void logout() {
    _sharedPref.logout(context);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void goToUpdatePage() {
    Navigator.pushNamed(context, 'client/update');
  }

  void goToOrderCreatePage() {
    Navigator.pushNamed(context, 'client/orders/list');
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

}