import 'package:flutter/cupertino.dart';
import 'package:hotel3/src/models/address.dart';
import 'package:hotel3/src/models/order.dart';
import 'package:hotel3/src/models/product.dart';
import 'package:hotel3/src/models/user.dart';
import 'package:hotel3/src/provider/orders_provider.dart';
import 'package:hotel3/src/utils/shared_pref.dart';



class ClientOrdersCreateController {

  BuildContext context;
  Function refresh;

  Product product;


  int counter = 1;
  double productPrice;

  final OrdersProvider _ordersProvider = OrdersProvider();

  final SharedPref _sharedPref = SharedPref();

  List<Product> selectedProducts = [];
  double total = 0;
  User user;
  Address address;
  

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    address = address;
    user = User.fromJson(await _sharedPref.read('user'));
    selectedProducts = Product.fromJsonList(await _sharedPref.read('order')).toList;
    _ordersProvider.init(context, user);

    getTotal();
    refresh();
  }

  void createOrder() async {
    List<Product> selectedProducts = Product.fromJsonList(await _sharedPref.read('order')).toList;
    //List<Address> selectedAddress = Address.fromJsonList(await _sharedPref.read('address')).toList;
    Address a = Address.fromJson(await _sharedPref.read('address') ?? {});
    Order order = Order(
      idClient: user.id,
      idAddress: address.id,
      //address: selectedAddress ,
      products: selectedProducts


    );
    // esras lineas de abajo crean la orden y la envian
    //ResponseApi responseApi = await _ordersProvider.create(order);

    //esta linea me manda al formulario de pago
    Navigator.pushNamed(context, 'client/address/create');

    //print('Respuesta orden ${responseApi.message}');
  }

  void getTotal() {
    total = 0;
    for (var product in selectedProducts) {
      total = total + (product.quantity * product.price);
    }
    refresh();
  }

  void addItem(Product product) {
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    selectedProducts[index].quantity = selectedProducts[index].quantity + 1;
    _sharedPref.save(('order'), selectedProducts);
    getTotal();
  }

  void removeItem(Product product) {
    if (product.quantity > 1) {
      int index = selectedProducts.indexWhere((p) => p.id == product.id);
      selectedProducts[index].quantity = selectedProducts[index].quantity - 1;
      _sharedPref.save(('order'), selectedProducts);
      getTotal();
    }
  }

  void deleteItem(Product product) {
    selectedProducts.removeWhere((p) => p.id == product.id);
    _sharedPref.save('order', selectedProducts);
    getTotal();
  }

  void goToAddress() {
    Navigator.pushNamed(context, 'client/address/create');
  }
}