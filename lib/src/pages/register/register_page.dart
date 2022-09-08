import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:hotel3/src/pages/client/address/create/validacion.dart';
import 'package:hotel3/src/pages/register/register_controller.dart';
import 'package:hotel3/src/utils/my_colors.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterControler _con = RegisterControler();

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
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(top: -80, left: -100, child: _circle()),
            Positioned(
              child: _textRegister(),
              top: 65,
              left: 27,
            ),
            Positioned(
              child: _iconBack(),
              top: 51,
              left: -5,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 150),
              child: SingleChildScrollView(
                child: ChangeNotifierProvider(
                    create: (_) => FormularioFromProvider(),
                    child: Builder(builder: (context) {
                      final formularioProvider =
                          Provider.of<FormularioFromProvider>(context,
                              listen: false);

                      return Form(
                        autovalidateMode: AutovalidateMode.always,
                        key: formularioProvider.formkey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              _imageUser(),
                              const SizedBox(height: 30),
                              TextFormField(
                                  controller: _con.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  /*  onChanged: (value) =>
                                        registerProvider.correo = value, */
                                  validator: (value) {
                                    if (!EmailValidator.validate(value ?? '')) {
                                      return 'Correo Invalido!';
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Ingrese su Correo',
                                      suffixIcon: Icon(
                                        Icons.email,
                                        color: MyColors.primarycolor,
                                      ))),
                              TextFormField(
                                  controller: _con.nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return ' El nombre es obligatorio';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Ingrese el nombre',
                                      suffixIcon: Icon(
                                        Icons.person,
                                        color: MyColors.primarycolor,
                                      ))),
                              TextFormField(
                                  controller: _con.lastNameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return ' El Apellido es obligatorio';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Ingrese Apellido',
                                      suffixIcon: Icon(
                                        Icons.person,
                                        color: MyColors.primarycolor,
                                      ))),
                              TextFormField(
                                  controller: _con.phoneController,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) => validateMobile(value),
                                  decoration: InputDecoration(
                                      labelText: 'Ingrese su telefono',
                                      suffixIcon: Icon(
                                        Icons.phone,
                                        color: MyColors.primarycolor,
                                      ))),
                              TextFormField(
                                  controller: _con.cedulaController,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) => validateCedula(value),
                                  decoration: InputDecoration(
                                      labelText: 'Ingrese su Cedula',
                                      suffixIcon: Icon(
                                        Icons.credit_score_outlined,
                                        color: MyColors.primarycolor,
                                      ))),
                              TextFormField(
                                  controller: _con.passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Ingrese su Contraseña';
                                    }

                                    if (value.length < 6) {
                                      return 'La Contraseña debe ser de 6 Caracteres';
                                    }

                                    return null;
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      labelText: 'Contraseña',
                                      suffixIcon: Icon(
                                        Icons.password_outlined,
                                        color: MyColors.primarycolor,
                                      ))),
                              TextFormField(
                                  controller: _con.confirmPasswordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Ingrese su Contraseña';
                                    }

                                    if (value.length < 6) {
                                      return 'La Contraseña debe ser de 6 Caracteres';
                                    }

                                    return null;
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      labelText: 'Confirmar contraseña',
                                      suffixIcon: Icon(
                                        Icons.password_outlined,
                                        color: MyColors.primarycolor,
                                      ))),
                              _buttonLogin(formularioProvider)
                            ],
                          ),
                        ),
                      );
                    })),
              ),
            )
          ],
        ),
      ),
    );
  }

  String validateMobile(String value) {
    if (value.isEmpty) {
      return 'Ingrese su Telefono';
    } else if (value.isNotEmpty) {
      bool mobileValid = RegExp(r'(^(?:[+0]10)?[0-9]{10,10}$)').hasMatch(value);
      return mobileValid ? null : "Numero de teléfono invalido";
    }
  }
  
  String validateCedula(String value) {
    if (value.isEmpty) {
      return 'Ingrese su Cédula ó Pasaporte';
    } else if (value.isNotEmpty) {
      bool mobileValid = RegExp(r'(^(?:[+0]10)?[0-9]{10,10}$)').hasMatch(value);
      return mobileValid ? null : "Cédula ó Pasaporte Invalido";
    }
  }

  Widget _imageUser() {
    return GestureDetector(
      onTap: _con.showAlertDialog,
      child: CircleAvatar(
        backgroundImage: _con.imageFile != null
            ? FileImage(_con.imageFile)
            : const AssetImage('assets/img/user_profile_2.png'),
        radius: 60,
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Widget _iconBack() {
    return IconButton(
        onPressed: _con.back,
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white));
  }

  Widget _textRegister() {
    return const Text('REGISTRO',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'NimbusSans'));
  }

  Widget _textFieldEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Correo Electrónico',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColors.primarycolorDark),
            prefixIcon: Icon(
              Icons.email,
              color: MyColors.primarycolor,
            )),
      ),
    );
  }

  Widget _textFieldName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.nameController,
        decoration: InputDecoration(
            hintText: 'Nombre',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColors.primarycolorDark),
            prefixIcon: Icon(
              Icons.person,
              color: MyColors.primarycolor,
            )),
      ),
    );
  }

  Widget _textFieldLastName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.lastNameController,
        decoration: InputDecoration(
            hintText: 'Apellido',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColors.primarycolorDark),
            prefixIcon: Icon(
              Icons.person_outline,
              color: MyColors.primarycolor,
            )),
      ),
    );
  }

  Widget _textFieldPhone() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Telefono',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColors.primarycolorDark),
            prefixIcon: Icon(
              Icons.phone,
              color: MyColors.primarycolor,
            )),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Contraseña',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColors.primarycolorDark),
            prefixIcon: Icon(
              Icons.lock,
              color: MyColors.primarycolor,
            )),
      ),
    );
  }

  Widget _textFieldConfirmPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: _con.confirmPasswordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Confirmar Contraseña',
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColors.primarycolorDark),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: MyColors.primarycolor,
            )),
      ),
    );
  }

  Widget _buttonLogin(FormularioFromProvider re) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: () {
          final validFrom = re.validateFrom(context);
          if (!validFrom) return;
          _con.register();
        },
        // onPressed: _con.isEnable ? _con.register : null,
        child: const Text('REGISTRARSE'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primarycolor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }

  Widget _circle() {
    return Container(
      width: 240,
      height: 230,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: MyColors.primarycolor),
    );
  }

  void refresh() {
    setState(() {});
  }
}
