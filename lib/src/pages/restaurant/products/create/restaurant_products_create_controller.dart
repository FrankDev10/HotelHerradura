import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:hotel3/src/models/category.dart';
import 'package:hotel3/src/models/product.dart';
import 'package:hotel3/src/models/response_api.dart';
import 'package:hotel3/src/models/user.dart';
import 'package:hotel3/src/provider/categories_provider.dart';
import 'package:hotel3/src/provider/products_provider.dart';
import 'package:hotel3/src/utils/my_snackbar.dart';
import 'package:hotel3/src/utils/shared_pref.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';


class RestaurantProductsCreateController {

  BuildContext context;
  Function refresh;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  MoneyMaskedTextController priceController = MoneyMaskedTextController();

  final CategoriesProvider _categoriesProvider = CategoriesProvider();
  final ProductsProvider _productsProvider = ProductsProvider();

  User user;
  SharedPref sharedPref = SharedPref();

  List<Category> categories = [];
  String idCategory; //ALMACENAR EL ID DE LA CATEGORIA SELECCIONADA

  // IMAGENES
  PickedFile pickedFile;
  File imageFile1;
  File imageFile2;
  File imageFile3;

  ProgressDialog _progressDialog;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _progressDialog = ProgressDialog(context: context);
    user =User.fromJson(await sharedPref.read('user'));
    _categoriesProvider.init(context, user);
    _productsProvider.init(context, user);
    getCategories();
  }

  void getCategories() async {
    categories = await _categoriesProvider.getAll();
    refresh();
  }

  void createProduct() async {
    String name = nameController.text;
    String description = descriptionController.text;
    double price = priceController.numberValue;

    if (name.isEmpty || description.isEmpty || price == 0) {
      MySnackbar.show(context, 'Debe ingresar todos los campos');
      return;
    }

    if (imageFile1 == null || imageFile2 == null || imageFile3 == null) {
      MySnackbar.show(context, 'Selecciona las tres imagenes ');
      return;
    }

    if (idCategory == null) {
      MySnackbar.show(context, 'Selecciona la categoria del producto');
      return;
    }

    Product product = Product(
      name: name,
      description: description,
      price: price,
      idCategory: int.parse(idCategory)
    );

    List<File> images = [];
    images.add(imageFile1);
    images.add(imageFile2);
    images.add(imageFile3);

    _progressDialog.show(max: 100, msg: 'Espere un momento');
    Stream stream = await _productsProvider.create(product, images);
    stream.listen((res) {
      _progressDialog.close();

      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      MySnackbar.show(context, responseApi.message);

      if (responseApi.success) {
        resetValues();
      }
    });

    print('Formulario producto, ${product.toJson()}');
  }

  void resetValues() {
    nameController.text = '';
    descriptionController.text = '';
   // priceController.text = '';
    imageFile1 = null;
    imageFile2 = null;
    imageFile3 = null;
    idCategory = null;
    refresh();
  }

  Future selectImage(ImageSource imageSource, int numberFile) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if(pickedFile != null) {

      if (numberFile == 1) {
        imageFile1 = File(pickedFile.path);
      }
      else if (numberFile == 2) {
        imageFile2 = File(pickedFile.path);
      }
      else if (numberFile == 3) {
        imageFile3 = File(pickedFile.path);
      }
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog(int numberFile) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery, numberFile);
        },
        child: const Text('GALERIA')
    );

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera, numberFile);
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


}