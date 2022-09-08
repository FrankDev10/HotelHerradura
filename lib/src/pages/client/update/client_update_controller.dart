import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hotel3/src/models/response_api.dart';
import 'package:hotel3/src/models/user.dart';
import 'package:hotel3/src/provider/users_provider.dart';
import 'package:hotel3/src/utils/my_snackbar.dart';
import 'package:hotel3/src/utils/shared_pref.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';


class ClientUpdateController {

  BuildContext context;
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;

  ProgressDialog _progressDialog;

  bool isEnable = true;
  User user;
  final SharedPref _sharedPref = SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    usersProvider.init(context);

    _progressDialog = ProgressDialog(context: context);
    user = User.fromJson(await _sharedPref.read('user'));
    //usersProvider.init(context, token: user.sessionToken); //  (luego se borral la liea de usersProvides init context)

    nameController.text = user.name;
    lastNameController.text = user.lastname;
    phoneController.text = user.phone;
    refresh();
  }

  void update() async {
    String name = nameController.text.trim();
    String lastname = lastNameController.text.trim();
    String phone = phoneController.text.trim();

    if(name.isEmpty || lastname.isEmpty || phone.isEmpty ){
      MySnackbar.show(context, 'Debes ingresar todos los campos');
      return ;
    }

    _progressDialog.show(max: 100, msg: 'Espere un momento..');
    isEnable = false;

    User myUser = User(
        id: user.id,
        name: name,
        lastname: lastname,
        phone: phone,
        image: user.image
    );

    Stream stream = await usersProvider.update(myUser, imageFile);
    stream.listen((res) async {

      _progressDialog.close();

      //ResponseApi responseApi = await usersProvider.list(user);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      Fluttertoast.showToast(msg: responseApi.message);

      if (responseApi.success) {
        user = await usersProvider.getById(myUser.id); // OBTENIENDO USARIOS DE LA BD
        print('Usuario obtenido: ${user.toJson()}');
        _sharedPref.save('user', user.toJson());
        Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);
        });
      }
      else {
        isEnable = true;
      }
    });
  }

  Future selectImage(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if(pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery);
        },
        child: const Text('GALERIA')
    );

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera);
        },
        child: const Text('CÁMARA')
    );

    AlertDialog alertDialog = AlertDialog(
      title: const Text('Selecciona tu imagen'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );
  }

  void back() {
    Navigator.pop(context);
  }
}