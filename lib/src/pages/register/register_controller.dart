import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotel3/src/models/response_api.dart';
import 'package:hotel3/src/models/user.dart';
import 'package:hotel3/src/provider/users_provider.dart';
import 'package:hotel3/src/utils/my_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class RegisterControler {
  BuildContext context;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cedulaController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  PickedFile pickedFile;
  File imageFile;
  Function refresh;

  ProgressDialog _progressDialog;

  bool isEnable = true;

  Future init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
    usersProvider.init(context);
    _progressDialog = ProgressDialog(context: context);
  }

  Future<void> register() async {
     
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String lastname = lastNameController.text.trim();
    String phone = phoneController.text.trim();
    String cedula = cedulaController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty ||
        name.isEmpty ||
        lastname.isEmpty ||
        phone.isEmpty ||
        cedula.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      MySnackbar.show(context, 'Debes ingresar todos los campos');
      return;
    }

    if (confirmPassword != password) {
      MySnackbar.show(context, 'Las contraseñas no coinciden');
      return;
    }

   if (phone.length <=9 ) {
      MySnackbar.show(
          context, 'El telefono icorrecto ingrese 10 Digitos');
      return;
    }
    /*  if (cedula == use?.cedula) {
      MySnackbar.show(context, 'La Cedula ya Existe');
      return;
    }  */
   /*    if (emailController == email) {
      MySnackbar.show(context, 'La Correo ya Existe');
      return;
    }  */ 

    if (password.length < 6) {
      MySnackbar.show(
          context, 'Las contraseñas debe tener al menos 6 caracteres');
      return;
    }

    /* if (imageFile == null) {
      MySnackbar.show(context, 'Selecciona una image');
      return;
    } */

  /*   _progressDialog.show(max: 330, msg: 'Espere un momento..');
    isEnable = false; */

    User user = User(
        email: email,
        name: name,
        lastname: lastname,
        phone: phone,
        cedula: cedula,
        password: password);


         ResponseApi  responseApi =await usersProvider.createWithImage(user);
      //MySnackbar.show(context, responseApi.message);
   
    if(responseApi.success){
     MySnackbar.show(context, responseApi.message);
    
    Future.delayed(Duration(seconds: 2), (){
        Navigator.pushReplacementNamed(context, 'login');
      });
  
     
    }else{
      MySnackbar.show(context, responseApi.message);
      //Fluttertoast.showToast(msg: responseApi.message);
     
    }
   /*  Stream stream = await usersProvider.createWithImage(user, imageFile);
    stream.listen((res) {
      _progressDialog.close();
      //ResponseApi responseApi = await usersProvider.list(user);
      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      print('RESPUESTA: ${responseApi.toJson()}');



      if (responseApi.success) {
      MySnackbar.show(context, responseApi.message);
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pushReplacementNamed(context, 'login');
        });
      } else {
         MySnackbar.show(context, responseApi.message);
        //isEnable = true;
      }
        
    }); */
  }

  Future selectImage(ImageSource imageSource) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
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
        child: const Text('GALERIA'));

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera);
        },
        child: const Text('CÁMARA'));

    AlertDialog alertDialog = AlertDialog(
      title: const Text('Selecciona tu imagen'),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void back() {
    Navigator.pop(context);
  }
}
