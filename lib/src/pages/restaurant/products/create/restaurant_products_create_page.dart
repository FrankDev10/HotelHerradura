import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hotel3/src/pages/restaurant/products/create/restaurant_products_create_controller.dart';
import 'package:hotel3/src/utils/my_colors.dart';



import '../../../../models/category.dart';

class RestaurantProductsCreatePage extends StatefulWidget {
  const RestaurantProductsCreatePage({Key key}) : super(key: key);

  @override
  State<RestaurantProductsCreatePage> createState() => _RestaurantProductsCreatePageState();
}

class _RestaurantProductsCreatePageState extends State<RestaurantProductsCreatePage> {

  final RestaurantProductsCreateController _con = RestaurantProductsCreateController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Habitación'),
      ),
      body: ListView( // EL LISTVIEW ES PARA HACER SCROOLL EN DIMENSIONES MAS PEQUENAS DE CELULARES
        children:[
          const SizedBox(height: 30),
          _textFieldName(),
          _textFieldDescription(),
          _textFieldPrice(),
          Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _cardImage(_con.imageFile1, 1),
                _cardImage(_con.imageFile2, 2),
                _cardImage(_con.imageFile3, 3),
              ],
            ),
          ),
          _dropDownCategories(_con.categories),
        ],
      ),
      bottomNavigationBar:  _buttonCreate(),
    );
  }

  Widget _textFieldName() {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.nameController,
        maxLines: 1,
        maxLength: 180,
        decoration: InputDecoration(
            hintText: 'Nombre del producto',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primarycolorDark
            ),
            suffixIcon: Icon(
              Icons.local_hotel_rounded,
              color: MyColors.primarycolor,)
        ),
      ),
    );

  }Widget _textFieldPrice() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.priceController,
        keyboardType: TextInputType.phone,
        maxLines: 1,
        decoration: InputDecoration(
            hintText: 'Precio',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primarycolorDark
            ),
            suffixIcon: Icon(
              Icons.monetization_on,
              color: MyColors.primarycolor,)
        ),
      ),
    );
  }

  Widget _dropDownCategories(List<Category> categories) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 33),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius:  const BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search,
                    color: MyColors.primarycolor,
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    'Categorias',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16
                    ),

                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      color: MyColors.primarycolor,
                    ),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: const Text(
                    'Selecciona la categoria',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16
                    ),
                  ),
                  items: _dropDownItems(categories),
                  value: _con.idCategory,
                  onChanged: (option) {
                    setState(() {
                      print('Categoria seleccionada $option');
                      _con.idCategory = option; //ESTABLECIENDO EL VALOR SELLECIONADO
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<Category> categories) {
    List<DropdownMenuItem<String>> list = [];
    for (var category in categories) {
      list.add(DropdownMenuItem(
          child: Text(category.name),
          value: category.id,
      ));
    }

    return list;
  }

  Widget _textFieldDescription() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.descriptionController,
        maxLines: 3,
        maxLength: 255,
        decoration: InputDecoration(
          hintText: 'Descripción de la categoria',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          hintStyle: TextStyle(
              color: MyColors.primarycolorDark
          ),
          suffixIcon: Icon(
            Icons.description,
            color: MyColors.primarycolor,
          ),
        ),
      ),
    );
  }

  Widget _cardImage(File imageFile, int numberFile) {
    return GestureDetector(
      onTap: () {
        _con.showAlertDialog(numberFile);
      },
      child: imageFile != null
      ? Card(
        elevation: 3.0,
        child: SizedBox(
          height: 140,
            width: MediaQuery.of(context).size.width * 0.26,
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
          ),
        ),
      )
      : Card(
        elevation: 3.0,
        child: SizedBox(
          height: 140,
          width: MediaQuery.of(context).size.width * 0.26,
          child: const Image(
              image: AssetImage('assets/img/add_image.png'),
          ),
        ),
      ),
    );
  }

  Widget _buttonCreate() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: _con.createProduct,
        child: const Text('Crear producto'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primarycolor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            padding: const EdgeInsets.symmetric(vertical: 15)
        ),
      ),
    );
  }

  void refresh() {
    setState(() {
    });
  }
}
