import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hotel3/src/models/address.dart';
import 'package:hotel3/src/models/order.dart';
import 'package:hotel3/src/models/product.dart';
import 'package:hotel3/src/models/response_api.dart';
import 'package:hotel3/src/models/user.dart';
import 'package:hotel3/src/pages/restaurant/orders/payments/restaurant_orders_payments_page.dart';
import 'package:hotel3/src/provider/address_provider.dart';
import 'package:hotel3/src/provider/orders_provider.dart';
import 'package:hotel3/src/provider/push_notifications_provider.dart';
import 'package:hotel3/src/provider/users_provider.dart';
import 'package:hotel3/src/utils/shared_pref.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:url_launcher/url_launcher.dart';

class RestaurantOrdersDetailController{

  BuildContext context;
  Function refresh;

  Product product;


  int counter = 1;
  double productPrice;

  final SharedPref _sharedPref = SharedPref();

  double total = 0;
  Order order;

  Address address;
  User user;
  List<User> users = [];
  final UsersProvider _usersProvider = UsersProvider();
  final OrdersProvider _ordersProvider = OrdersProvider();
  final AddressProvider _addressProvider = AddressProvider();
  //String idClient;

  PushNotificationsProvider pushNotificationsProvider = PushNotificationsProvider();

  Future init(BuildContext context, Function refresh, Order order) async {
    this.context = context;
    this.refresh = refresh;
    this.order = order;
    user = User.fromJson(await _sharedPref.read('user'));
    _usersProvider.init(context,  sessionUser: user);
    _ordersProvider.init(context, user);
    //_addressProvider.init(context, user);
    getTotal();
    refresh();
  }

  void openBottomSheet() {
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => const RestaurantOrdersPaymentsPage()
    );
  }

  void sendNotification(String tokenClient) {
    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    };

    pushNotificationsProvider.sendMessage(
        tokenClient,
        data,
        'PEDIDO RECIBIDO',
        'Tu reserva ha sido agendada con éxito.'
    );
  }

  void updateOrder() async {
    //order.idClient = idClient;
    ResponseApi responseApi = await _ordersProvider.updateToInUse(order);

    User clientUser = await _usersProvider.getById(order.idClient);
    print('TOKEN DE NOTIFICACION DEL CLIENTE: ${clientUser.notificationToken}');

    sendNotification(clientUser.notificationToken);

    Fluttertoast.showToast(msg: responseApi.message, toastLength: Toast.LENGTH_LONG);
    Navigator.pop(context, true);
  }

  void updateOrderTerminate() async {
    //order.idClient = idClient;
    ResponseApi responseApi = await _ordersProvider.  updateToTerminate(order);

     User clientUser = await _usersProvider.getById(order.idClient);
    // print('TOKEN DE NOTIFICACION DEL CLIENTE: ${clientUser.notificationToken}');
    //
    // sendNotification(clientUser.notificationToken);

    Fluttertoast.showToast(msg: responseApi.message, toastLength: Toast.LENGTH_LONG);
    Navigator.pop(context, true);
  }

  void getTotal() {
    total = 0;
    for (var product in order.products) {
      total = total + (product.price * product.quantity);
    }
    refresh();
  }

  void call() {
    launch("tel://${order.client.phone}");
  }



}