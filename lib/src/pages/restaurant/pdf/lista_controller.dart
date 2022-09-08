import 'package:flutter/cupertino.dart';
import 'package:hotel3/src/models/order.dart';
import 'package:hotel3/src/models/user.dart';
import 'package:hotel3/src/provider/orders_provider.dart';
import 'package:hotel3/src/provider/users_provider.dart';
import 'package:hotel3/src/utils/shared_pref.dart';


class ListExcelController {
  BuildContext context;
  Function refresh;

  final SharedPref _sharedPref = SharedPref();

  final UsersProvider _usersProvider = UsersProvider();
  final OrdersProvider _orderProvider = OrdersProvider();
  final OrdersProvider _ordersProvider = OrdersProvider();
  User user;
  List<Order> listOrder = [];

  Future init(
    BuildContext context,
    Function refresh,
  ) async {
    this.context = context;
    this.refresh = refresh;

    user = User.fromJson(await _sharedPref.read('user'));
    _usersProvider.init(context, sessionUser: user);
    _ordersProvider.init(context, user);

    _orderProvider.init(context, user);
    //_addressProvider.init(context, user);

    listarOrder();
    refresh();
  }

  void listarOrder() async {
    listOrder = await _ordersProvider.ListaExcel();
    refresh();
  }
}
