import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hotel3/src/pages/client/update/client_update_controller.dart';
import 'package:hotel3/src/utils/my_colors.dart';



class ClientUpdatePage extends StatefulWidget {
  const ClientUpdatePage({Key key}) : super(key: key);

  @override
  _ClientUpdatePageState createState() => _ClientUpdatePageState();
}

class _ClientUpdatePageState extends State<ClientUpdatePage> {

  final ClientUpdateController _con = ClientUpdateController();

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
        title: const Text('Editar perfil'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              _imageUser(),
              const SizedBox(height: 30),
              _textFieldName(),
              _textFieldLastName(),
              _textFieldPhone(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buttonLogin(),
    );
  }

  Widget _imageUser() {
    return GestureDetector(
      onTap: _con.showAlertDialog,
      child: CircleAvatar(
        backgroundImage: _con.imageFile != null
            ? FileImage(_con.imageFile)
            : _con.user?.image != null
              ? NetworkImage(_con.user?.image)
              : const AssetImage('assets/img/user_profile_2.png'),
        radius: 60,
        backgroundColor: Colors.grey[200],
      ),
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
            hintText: 'Nombre',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primarycolorDark
            ),
            prefixIcon: Icon(
              Icons.person,
              color: MyColors.primarycolor,)
        ),
      ),
    );
  }

  Widget _textFieldLastName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.lastNameController,
        decoration: InputDecoration(
            hintText: 'Apellido',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primarycolorDark
            ),
            prefixIcon: Icon(
              Icons.person_outline,
              color: MyColors.primarycolor,)
        ),
      ),
    );
  }

  Widget _textFieldPhone() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Telefono',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primarycolorDark
            ),
            prefixIcon: Icon(
              Icons.phone,
              color: MyColors.primarycolor,)
        ),
      ),
    );
  }

  Widget _buttonLogin() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: _con.isEnable ? _con.update : null,
        child: const Text('ACTUALIZAR PERFIL'),
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
    setState(() {});
  }
}
