import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hotel3/src/models/product.dart';
import 'package:hotel3/src/utils/shared_pref.dart';



class ClientsProductsDetailController {

  BuildContext context;
  Function refresh;

  Product product;

  int counter = 1;
  double productPrice;

  final SharedPref _sharedPref = SharedPref();

  List<Product> selectedProducts = [];

  Future init(BuildContext context, Function refresh, Product product) async {
    this.context = context;
    this.refresh = refresh;
    this.product = product;
    productPrice = product.price;

    //_sharedPref.remove('order');
    selectedProducts = Product.fromJsonList(await _sharedPref.read('order')).toList;

    for (var p in selectedProducts) {
      print('Producto seleccionado: ${p.toJson()}');
    }


    refresh();
  }

  void addToBag() {
    int index = selectedProducts.indexWhere((p) => p.id == product.id);

    if(index == -1) { // PRODUCTOS SELECCIONADOS NO EXISTE ESE PRODUCTO
      product.quantity ??= 1;

      selectedProducts.add(product);
    }
    else {
      selectedProducts[index].quantity = counter;
    }

    _sharedPref.save('order', selectedProducts);
    Fluttertoast.showToast(msg: 'Producto agregado');

  }

  void addItem() {
    counter = counter + 1;
    productPrice = product.price * counter;
    product.quantity = counter;
    refresh();
  }

  void removeItem() {
    if (counter > 1) {
      counter = counter - 1;
      productPrice = product.price * counter;
      product.quantity = counter;
      refresh();
    }
  }

  void close() {
    Navigator.pop(context);
  }

}