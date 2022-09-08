import 'package:flutter/material.dart';
import 'package:hotel3/src/models/address.dart';
import 'package:hotel3/src/models/order.dart';
import 'package:hotel3/src/models/user.dart';
import 'package:hotel3/src/pages/restaurant/orders/detail/restaurant_orders_detail_page.dart';
import 'package:hotel3/src/provider/orders_provider.dart';
import 'package:hotel3/src/utils/shared_pref.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class RestaurantOrdersListController {

  BuildContext context;
  final SharedPref _sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  Function refresh;
  User user;
  Address address;

  List<String> status = ['PAGADO', 'EN USO', 'TERMINADO'];
  final OrdersProvider _ordersProvider = OrdersProvider();

  bool isUpdate;

  Order order;

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    //this.address = address;
    user = User.fromJson(await _sharedPref.read('user'));
    //this.address = address;
    _ordersProvider.init(context, user);
    refresh();
  }

  Future<List<Order>> getOrders(String status) async {
    //print('PRUEBA: ${getOrders(status).toString()}');
    return await _ordersProvider.getByStatus(status);

  }

  void openBottomSheet(Order order ) async {
    isUpdate = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => RestaurantOrdersDetailPage(order: order)
    );

      refresh();
   /*  if(isUpdate) {
    } */
  }


  void logout() {
    _sharedPref.logout(context);
  }

  void goToCategoryCreate() {
    Navigator.pushNamed(context, 'restaurant/categories/list');
  }

  void goToProductCreate() {
    Navigator.pushNamed(context, 'restaurant/products/list');
  }
  void irPdf() {
    Navigator.pushNamed(context, 'irapdf');
  }
  void listaHabitacion() {
    Navigator.pushNamed(context, 'listaHabitacion');
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

}