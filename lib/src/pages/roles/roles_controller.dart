import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel3/src/models/user.dart';
import 'package:hotel3/src/utils/shared_pref.dart';



class RolesController {

  BuildContext context;
  Function refresh;

  User user;
  SharedPref sharedPref = SharedPref();

  Future init(BuildContext context, Function refresh) async {
   
     this.context = context;
    this.refresh = refresh;

    // OBTENEMOS EL USARIO DE SESSION
    user = User.fromJson(await sharedPref.read('user'));
    refresh ();
  }

  void goToPage(String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }
}