import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hotel3/src/pages/restaurant/categories/create/restaurant_categories_create_controller.dart';
import 'package:hotel3/src/utils/my_colors.dart';



class RestaurantCategoriesCreatePage extends StatefulWidget {
  const RestaurantCategoriesCreatePage({Key key}) : super(key: key);

  @override
  State<RestaurantCategoriesCreatePage> createState() => _RestaurantCategoriesCreatePageState();
}

class _RestaurantCategoriesCreatePageState extends State<RestaurantCategoriesCreatePage> {

  final RestaurantCategoriesCreateController _con = RestaurantCategoriesCreateController();

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
        title: const Text('Nueva Categoría'),
      ),
      body: Column(
        children:[
            const SizedBox(height: 30),
          _textFieldName(),
          _textFieldDescription()
        ],
      ),
      bottomNavigationBar:  _buttonCreate(),
    );
  }

  Widget _textFieldName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.nameController,
        decoration: InputDecoration(
            hintText: 'Nombre de la categoria',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primarycolorDark
            ),
            suffixIcon: Icon(
              Icons.list_alt,
              color: MyColors.primarycolor,)
        ),
      ),
    );
  }

  Widget _textFieldDescription() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
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

  Widget _buttonCreate() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: _con.createCategory,
        child: const Text('Crear categoria'),
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
