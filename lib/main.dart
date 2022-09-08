
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hotel3/splashScreenPage.dart';
import 'package:hotel3/src/pages/client/address/create/client_address_create_page.dart';
import 'package:hotel3/src/pages/client/orders/create/client_orders_create_page.dart';
import 'package:hotel3/src/pages/client/payments/create/client_payments_create_page.dart';
import 'package:hotel3/src/pages/client/products/list/client_products_list_page.dart';
import 'package:hotel3/src/pages/client/update/client_update_page.dart';
import 'package:hotel3/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:hotel3/src/pages/login/login_page.dart';
import 'package:hotel3/src/pages/register/register_page.dart';
import 'package:hotel3/src/pages/restaurant/categories/create/restaurant_categories_create_page.dart';
import 'package:hotel3/src/pages/restaurant/lista_habitaciones/listahabitacion.dart';
import 'package:hotel3/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:hotel3/src/pages/restaurant/pdf/lista.dart';
import 'package:hotel3/src/pages/restaurant/products/create/restaurant_products_create_page.dart';
import 'package:hotel3/src/pages/roles/roles_page.dart';
import 'package:hotel3/src/provider/push_notifications_provider.dart';
import 'package:hotel3/src/utils/my_colors.dart';




PushNotificationsProvider pushNotificationsProvider = PushNotificationsProvider();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
 
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  pushNotificationsProvider.initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {


@override
  void initState() {
    // TODO: implement initState
    super.initState();

    pushNotificationsProvider.onMessageListener();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hotel La Herradura",
      debugShowCheckedModeBanner: false,
      initialRoute: 'SplashScreen',
      routes: {
        'SplashScreen': (BuildContext context) => const SplashScreenPage(),
        'login': (BuildContext context) => const LoginPage(),
        'register': (BuildContext context) => const RegisterPage(),
        'roles': (BuildContext context) => const RolesPage(),
        'client/products/list': (BuildContext context) => const ClientProductsListPage(),
        'client/update': (BuildContext context) => const ClientUpdatePage(),
        'client/orders/list': (BuildContext context) => const ClientOrdersCreatePage(),
        'client/payments/create': (BuildContext context) => const ClientPaymentsCreatePage(),
        'client/address/create': (BuildContext context) => const ClientAddressCreatePage(),
        'restaurant/orders/list': (BuildContext context) => const RestaurantOrdersListPage(),
        'restaurant/categories/list': (BuildContext context) => const RestaurantCategoriesCreatePage(),
        'restaurant/products/list': (BuildContext context) => const RestaurantProductsCreatePage(),
        'delivery/orders/list': (BuildContext context) => const DeliveryOrdersListPage(),
        'listaHabitacion': (BuildContext context) => const ListaHabiatcion(),
        'irapdf': (BuildContext context) => const Lista(),
      },


      // YA NO FUNCIONA PRIMARYCOLOR POR FUNCIONES DE FLUTER
      // AHORA COLORSCHEME

      theme: ThemeData(
        //fontFamily: 'NimbusSans',
        colorScheme: const ColorScheme.light().copyWith(primary:  MyColors.primarycolor,),
        appBarTheme: const AppBarTheme(elevation: 0)
      ),
    );
  }
}
