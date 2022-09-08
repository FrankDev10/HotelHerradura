import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hotel3/src/models/address.dart';
import 'package:hotel3/src/models/order.dart';
import 'package:hotel3/src/models/rol.dart';
import 'package:hotel3/src/models/product.dart';
import 'package:hotel3/src/models/response_api.dart';
import 'package:hotel3/src/models/user.dart';
import 'package:hotel3/src/provider/address_provider.dart';
import 'package:hotel3/src/provider/push_notifications_provider.dart';
import 'package:hotel3/src/provider/orders_provider.dart';
import 'package:hotel3/src/utils/my_snackbar.dart';
import 'package:hotel3/src/utils/shared_pref.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';


import '../../../../provider/push_notifications_provider.dart';
import '../../../../provider/users_provider.dart';

class ClientAddressCreateController {

  BuildContext context;
  Function refresh;

  PickedFile pickedFile;
  File imageFile;

  Order order;

  Rol rol;

  Product product;

  ProgressDialog  _progressDialog;

  bool isEnable = true;

  TextEditingController addressController= TextEditingController();
  TextEditingController countryController= TextEditingController();
  TextEditingController cedulaController= TextEditingController();
  TextEditingController arrivalDateController= TextEditingController();
  TextEditingController hourArrivalController= TextEditingController();
  TextEditingController departureDateController= TextEditingController();
  TextEditingController numberPeopleController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();
  TextEditingController paymentNumberController= TextEditingController();

  AddressProvider addressProvider = AddressProvider();
  User user;
  Address address;
  final OrdersProvider _ordersProvider = OrdersProvider();
  final UsersProvider _usersProvider = UsersProvider();

  PushNotificationsProvider pushNotificationsProvider = PushNotificationsProvider();

  final SharedPref _sharedPref = SharedPref();
  List<Product> selectedProducts = [];

  //List<Address> selectedAddress = [];

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    //address = Address.fromJson(await _sharedPref.read('address'));
    user = User.fromJson(await _sharedPref.read('user'));
    _usersProvider.init(context,  sessionUser: user);

    addressProvider.init(context, user);
    _progressDialog = ProgressDialog(context: context);
  }

  void createOrder() async {
    List<Product> selectedProducts = Product.fromJsonList(await _sharedPref.read('order')).toList;
    //Address a = Address.fromJson(await _sharedPref.read('address') ?? {});
    Order order = Order(
        idClient: user.id,
        //idAddress: a.address,
        products: selectedProducts

    );
    // esras lineas de abajo crean la orden y la envian
    ResponseApi responseApi = await _ordersProvider.create(order);

    //esta linea me manda al formulario de pago
    Navigator.pushNamed(context, 'client/address/create');

    print('Respuesta orden ${responseApi.message}');
    //createAddress();
  }

  // SECCION DE CREAR EL FORMULARIO ABAJO..
 

  void createAddress() async {



    String addressName = addressController.text.trim();
    String country = countryController.text.trim();
    String cedula = cedulaController.text.trim();
    String arrival = arrivalDateController.text.trim();
    String hourArrival = hourArrivalController.text.trim();
    String departure = departureDateController.text.trim();
    String numberPeople = numberPeopleController.text.trim();
    String paymentNumber = paymentNumberController.text.trim();
    String description = descriptionController.text.trim();

    if (addressName.isEmpty || country.isEmpty || arrival.isEmpty ||
    hourArrival.isEmpty || departure.isEmpty || numberPeople.isEmpty || description.isEmpty) {
      MySnackbar.show(context, 'Complete todos los campos');
      return;
    }

    if (imageFile == null) {
      MySnackbar.show(context, 'Subir el voucher del pago ');
      return;
    }

    _progressDialog.show(max: 350, msg: 'Espere un momento..');
    isEnable = false;

    Address address = Address(
        address: addressName,
        country: country,
        cedula: cedula,
        arrival: arrival,
        hourArrival: hourArrival,
        departure: departure,
        numberPeople: numberPeople,
        paymentNumber: paymentNumber,
        description: description,
        idUser: user.id

    );



    Stream stream = await addressProvider.createWithImage(address, imageFile);
    stream.listen((res) {
      _progressDialog.close();

      ResponseApi responseApi =  ResponseApi.fromJson(json.decode(res));
      print('RESPUESTA: ${responseApi.toJson()}');


      // User clientUser = await _usersProvider.crate(order.idClient);
      // print('TOKEN DE NOTIFICACION DEL CLIENTE: ${clientUser.notificationToken}');
      //
      sendNotification(user.notificationToken);

      MySnackbar.show(context, responseApi.message);

      if (responseApi.success) {
        Future.delayed(const Duration(seconds: 4), () {
          Navigator.pushReplacementNamed(context, 'login');
        });
      }
      else {
        isEnable = true;

      }
    });

    // LLAMAMOS AL METODO O FUNCION PARA CREAR AL ORDEN AL MISMO TIEMPO EN EL BOTON
    createOrder();

    resetValues();
  }

  void resetValues(){
    addressController.text = '';
    countryController.text = '';
    cedulaController.text = '';
    arrivalDateController.text = '';
    hourArrivalController.text = '';
    departureDateController.text = '';
    numberPeopleController.text = '';
    imageFile = null ;
    descriptionController.text = '';
    refresh();
  }



  void sendNotification(String tokenClient) {
    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    };

    pushNotificationsProvider.sendMessage(
        tokenClient,
        data,
        'PETICIÓN DE RESERVA',
        'Te  ha llegado una nueva petición de pedido y reserva'
    );
  }

  void updateOrder() async {
    //order.idClient = idClient;
    ResponseApi responseApi = await _ordersProvider.updateToInUse(order);

    User clientUser = await _usersProvider.getById(rol.id);
    print('TOKEN DE NOTIFICACION DEL CLIENTE: ${clientUser.notificationToken}');

    sendNotification(clientUser.notificationToken);

    Fluttertoast.showToast(msg: responseApi.message, toastLength: Toast.LENGTH_LONG);
    Navigator.pop(context, true);
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
      title: const Text('Selecciona una imagen'),
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


}