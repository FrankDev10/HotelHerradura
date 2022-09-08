import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hotel3/src/pages/client/address/create/client_address_create_controller.dart';
import 'package:hotel3/src/pages/client/address/create/validacion.dart';
import 'package:hotel3/src/utils/my_colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ClientAddressCreatePage extends StatefulWidget {
  const ClientAddressCreatePage({Key key}) : super(key: key);

  @override
  State<ClientAddressCreatePage> createState() =>
      _ClientAddressCreatePageState();
}

class _ClientAddressCreatePageState extends State<ClientAddressCreatePage> {
  var _currentSelectedDate;

  void callDatePicker() async {
    var selectedDate = await getDatePickerWidget();
    setState(() {
      _currentSelectedDate = selectedDate;
    });
  }

  final ClientAddressCreateController _con = ClientAddressCreateController();

  @override
  void initState() {
    // TODO:IMPLEMENT INItState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  Future<DateTime> getDatePickerWidget() {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime(2023),
        builder: (context, child) {
          return Theme(data: ThemeData.light(), child: child);
        });
  }

  final format = DateFormat("yyyy-MM-dd");
  final hora = DateFormat("HH:mm");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario'),
      ),
      //bottomNavigationBar: _buttonAccept(),
      body: ChangeNotifierProvider(
          create: (_) => FormularioFromProvider(),
          child: Builder(builder: (context) {
            final formularioProvider =
                Provider.of<FormularioFromProvider>(context, listen: false);
            return Form(
              autovalidateMode: AutovalidateMode.always,
              key: formularioProvider.formkey,
              child: ListView(
                children: [
                  _textCompleteData(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    child: TextFormField(
                      controller: _con.addressController,
                      decoration: InputDecoration(
                          labelText: 'Dirección, ciudad',
                          suffixIcon: Icon(
                            Icons.location_on,
                            color: MyColors.primarycolor,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ' Dirección, ciudades Obligatorio';
                        }
                        return null;
                      },
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: TextFormField(
                      controller: _con.countryController,
                      decoration: InputDecoration(
                          labelText: 'País',
                          suffixIcon: Icon(
                            Icons.location_on,
                            color: MyColors.primarycolor,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'País Obligatorio';
                        }
                        return null;
                      },
                    ),
                  ),

                 /*  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: TextFormField(
                      controller: _con.cedulaController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: 'Cédula o Pasaporte',
                          //border: InputBorder.none,
                          suffixIcon: Icon(
                            Icons.perm_identity,
                            color: MyColors.primarycolor,
                          )),
                      validator: (value) => validateMobile(value),
                    ),
                  ), */

                  _textSubirVoucher(),
                  _cardNumberCuenta(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _con.numberPeopleController,
                      decoration: InputDecoration(
                          labelText: 'Numero de Comprobante',
                          suffixIcon: Icon(
                            Icons.numbers,
                            color: MyColors.primarycolor,
                          )),
                      /* validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Numero de Comprobante Obligatorio';
                        return null;
                      }, */
                      validator: (value) => validateNumeroComrpbante(value),
                    ),
                  ),

                  /// comento porque me llegaba null a la base de datos el codigo de pago
                  ///_textFieldPaymetNumber(),
                  _imageVoucher(_con.imageFile),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: TextFormField(
                      controller: _con.descriptionController,
                      maxLines: 2,
                      maxLength: 255,
                      decoration: InputDecoration(
                          labelText: 'Notas Especiales',
                          suffixIcon: Icon(
                            Icons.pending_actions,
                            color: MyColors.primarycolor,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Notas Especiales Obligatorio';
                        }
                        return null;
                      },
                    ),
                  ),
                  // _textFieldArrivalDate(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: DateTimeField(
                      controller: _con.arrivalDateController,
                      format: format,
                      validator: (value) {
                        if (value == null) {
                          return 'La fecha de llegada es Obligatorio';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Fecha de llegada',
                          suffixIcon: Icon(
                            Icons.date_range_outlined,
                            color: MyColors.primarycolor,
                          )),
                      style: const TextStyle(color: Colors.black),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                    ),
                  ),
                   
                  
               Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: DateTimeField(
                      controller: _con.hourArrivalController,
                      format: hora,
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.convert(time);
                      },
                      decoration: InputDecoration(
                          labelText: 'Hora de llegada',
                          suffixIcon: Icon(
                            Icons.punch_clock,
                            color: MyColors.primarycolor,
                          )),
                      validator: (value) {
                        if (value == null || value.isUtc) {
                          return 'La hora es Obligatorio';
                        }
                        return null;
                      },
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: DateTimeField(
                      controller: _con.departureDateController,
                      format: format,
                      validator: (value) {
                        if (value == null) {
                          return 'La fecha de salida es Obligatorio';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Fecha de Salida',
                          suffixIcon: Icon(
                            Icons.date_range_outlined,
                            color: MyColors.primarycolor,
                          )),
                      style: const TextStyle(color: Colors.black),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                    ),
                  ),
 
                  
                  
                  //_textFieldDepartureDate(),
                  //_textFieldNumberPerson(),
                  //_cardImage()

                  _buttonAccept(formularioProvider)
                ],
              ),
            );
          })),
    );
  }

  String validateMobile(String value) {
    if (value.isEmpty) {
      return 'Ingrese su Cedula';
    } else if (value.isNotEmpty) {
      bool mobileValid = RegExp(r'(^(?:[+0]9)?[0-9]{10,10}$)').hasMatch(value);
      return mobileValid ? null : "Numero Invalido";
    }
  }

  String validateNumeroComrpbante(String value) {
    if (value.isEmpty) {
      return 'Numero de Comprobante';
    } else if (value.isNotEmpty) {
      bool mobileValid = RegExp(r'(^(?:[+0]9)?[0-9]{6,12}$)').hasMatch(value);
      return mobileValid ? null : "Numero de Comprobante invalido";
    }
  }

  /* Widget _textFieldDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.descriptionController,
        maxLines: 2,
        maxLength: 255,
        decoration: InputDecoration(
            labelText: 'Notas Especiales',
            suffixIcon: Icon(
              Icons.pending_actions,
              color: MyColors.primarycolor,
            )
        ),
      ),
    );
  } */

  Widget _textSubirVoucher() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Text(
        'Subir imagen del voucher de pago',
        style: TextStyle(
            fontSize: 19,
            color: MyColors.primarycolorDark,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  /*  Widget _textFieldAddress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        controller: _con.addressController,
        decoration: InputDecoration(
            labelText: 'Dirección, ciudad',
            suffixIcon: Icon(
              Icons.location_on,
              color: MyColors.primarycolor,
            )
        ),
        validator: (value){
          if(!value.isEmpty ||!RegExp(r'^[a-z A-Z]+$').hasMatch(value)){
            return "Ingrese nombres correctos";
          }else{
            return null;
          }
        },
      ),
    );
  } */

  /* Widget _textFieldCountry() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextFormField(
        controller: _con.countryController,
        decoration: InputDecoration(
            labelText: 'País',
            suffixIcon: Icon(
              Icons.location_on,
              color: MyColors.primarycolor,
            )
        ),
      ),
    );
  } */

  Widget _textFieldArrivalDate() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextFormField(
        controller: _con.arrivalDateController,
        decoration: InputDecoration(
            labelText: 'Fecha de llegada',
            suffixIcon: Icon(
              Icons.date_range_outlined,
              color: MyColors.primarycolor,
            )),
      ),
    );
  }

/*   Widget _textFieldArrivalHour() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextFormField(
        controller: _con.hourArrivalController,
        decoration: InputDecoration(
            labelText: 'Hora de llegada',
            suffixIcon: Icon(
              Icons.punch_clock,
              color: MyColors.primarycolor,
            )
        ),
      ),
    );
  } */

  /* Widget _textFieldDepartureDate() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextFormField(
        controller: _con.departureDateController,
        decoration: InputDecoration(
            labelText: 'Fecha de salida',
            suffixIcon: Icon(
              Icons.date_range,
              color: MyColors.primarycolor,
            )
        ),
      ),
    );
  } */

  /*  Widget _textFieldIdentityCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextFormField(
        controller: _con.cedulaController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            labelText: 'Cédula o Pasaporte',
            //border: InputBorder.none,
            suffixIcon: Icon(
              Icons. perm_identity,
              color: MyColors.primarycolor,
            )
        ),
      ),
    );
  } */

  /*  Widget _textFieldNumberPerson() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextFormField(
        controller: _con.numberPeopleController,
        decoration: InputDecoration(
            labelText: 'Numero de Comprobante',
            suffixIcon: Icon(
              Icons.numbers,
              color: MyColors.primarycolor,
            )
        ),
      ),
    );
  } */

  Widget _textCompleteData() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Text(
        'Completa los siguientes datos',
        style: TextStyle(
            color: MyColors.primarycolorDark,
            fontSize: 19,
            fontWeight: FontWeight.bold),
      ),
    );
  }

/*   Widget _textFieldPaymetNumber() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextFormField(
        controller: _con.paymentNumberController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            labelText: 'Numero de Comprobante',
            //border: InputBorder.none,
            suffixIcon: Icon(
              Icons. numbers,
              color: MyColors.primarycolor,
            )
        ),
      ),
    );
  } */

  Widget _imageVoucher(File imageFile) {
    return GestureDetector(
      onTap: () {
        _con.showAlertDialog();
      },
      child: imageFile != null
          ? Card(
              margin: const EdgeInsets.symmetric(horizontal: 150),
              elevation: 3.0,
              child: SizedBox(
                height: 140,
                width: MediaQuery.of(context).size.width * 0.26,
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              ))
          : Card(
              margin: const EdgeInsets.symmetric(horizontal: 150),
              elevation: 3.0,
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 100,
                width: MediaQuery.of(context).size.width * 0.26,
                child: const Image(
                  image: AssetImage('assets/img/add_image.png'),
                ),
              ),
            ),
    );
  }

  Widget _buttonAccept(FormularioFromProvider form) {
    return Container(
      height: 40,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: ElevatedButton(
        onPressed: () {
          final validFrom = form.validateFrom(context);
          if (!validFrom) return;
          _con.createAddress();
        },
        child: const Text(
          'Aceptar',
          style: TextStyle(fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            primary: MyColors.primarycolor),
      ),
    );
  }

  Widget _cardNumberCuenta() {
    return Container(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 155,
        child: Card(
          elevation: 3.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width * 1,
                decoration: const BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: const Text(
                    'BANCO PICHINCHA',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        fontFamily: 'NimbusSans'),
                  ),
                ),
              )),
              Container(
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: const Text(
                        'Cta. Ahorros ',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: const Text(
                        'Número:  2206592034 ',
                        style: TextStyle(fontSize: 13),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: const Text(
                        'Nombre:  Peñaherrera Buste César Alfonso ',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
