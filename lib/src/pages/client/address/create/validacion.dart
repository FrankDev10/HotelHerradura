import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FormularioFromProvider extends ChangeNotifier {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  validateFrom(context) {
    if (formkey.currentState.validate()) {
      return true;
    } else {
      _showAlertDialog(context, 'POR FAVOR INGRESE BIEN LOS DATOS');

      return false;
    }
  }
}

void _showAlertDialog(context, String msg) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (buildcontext) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: Container(
              width: 90,
              height: 100,
              child: Column(
                children: [
                  Text(msg,
                      style: const TextStyle(fontSize: 18),
                      maxLines: 2,
                      textAlign: TextAlign.center),
                  const SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                      color: Colors.red,
                      child: const Text('Cerrar'),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              )),
        );
      });
}
