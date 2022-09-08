import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hotel3/src/models/address.dart';
import 'package:hotel3/src/pages/restaurant/orders/payments/restaurant_orders_payments_controller.dart';


class RestaurantOrdersPaymentsPage extends StatefulWidget {
  const RestaurantOrdersPaymentsPage({Key key}) : super(key: key);

  @override
  State<RestaurantOrdersPaymentsPage> createState() => _RestaurantOrdersPaymentsPageState();
}

class _RestaurantOrdersPaymentsPageState extends State<RestaurantOrdersPaymentsPage> {


  final RestaurantOrdersPaymentsController _con = RestaurantOrdersPaymentsController();
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
        title: const Text('Verificación de Pago'),
      ),
      //bottomNavigationBar: _buttonAccept(),
      body: ListView(
        children: [
          //_formoularioDire('${_con.address.description}')
          //_textData('Cliente:', '${_con.order?.client?.id ?? ""} ${_con.order?.client?.name ?? ""} ${_con.order?.client?.lastname ?? ""}'),
          // _textData('Cliente:', '${_con.order?.client?.id ?? ""} ${_con.order?.client?.name ?? ""} ${_con.order?.client?.lastname ?? ""}'),
          //_textData('Correo:', '${ _con.address} '),
          _textData('Numero de Comprobante de pago:', '97483676'),
          _imageVocuher(),
          _textData('Direccion:', '${_con.order}'),
          _textData('País:', 'Ecuador'),
          _textData('Cédula / Pasaporte:', '0504330325'),
          _textData('Fecha de llegada:', '20 Agosto del 2022'),
          _textData('Hora de llegada:', '09:00 AM'),
          _textData('Fecha de salida:', '22 Agosto del 2022'),
          _textData('Número de personas:', '2'),
          _textData('Descripción:', 'Aqui adujunto mi vpucher del pago'),


          //_cardImage()
        ],
      ),
    );
  }


  // Widget _listAddress() {
  //   return FutureBuilder(
  //     future: _con.getAddress(),
  //     builder: (context, AsyncSnapshot<List<Address>> snapshot) {
  //
  //       if (snapshot.hasData) {
  //
  //         if (snapshot.data.length > 0) {
  //           return ListView.builder(
  //               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
  //               itemCount: snapshot.data?.length ?? 0,
  //               itemBuilder: (_, index) {
  //                 //return _cardProduct(snapshot.data[index]);
  //               }
  //           );
  //         }
  //         else {
  //           return NoDataWidget(text: 'No hay productos');
  //         }
  //
  //       }
  //       else {
  //         return NoDataWidget(text: 'No hay productos');
  //       }
  //
  //
  //     },
  //   );
  // }

  Widget _formoularioDire( Address address) {
    return Container(
      child: Column(
        children: [
          Text(
            address?.address ?? '',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
  
  Widget _textData(String title, String content) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          title: Text(title),
          subtitle: Text(
            content,
            maxLines: 2,
          ),
        ));
  }

  Widget _imageVocuher(){
    return Container(
      height: 500,
      margin: const EdgeInsets.only(top: 10),
      child: const Image(
        image: AssetImage('assets/img/voucher.jpg'),
      ),
      // child: FadeInImage(
      //   image: _con.user?.image != null
      //       ? NetworkImage(_con.user?.image)
      //       : AssetImage('assets/img/no-image.png'),
      //   fit: BoxFit.contain,
      //   fadeInDuration: Duration(milliseconds: 50),
      //   placeholder: AssetImage('assets/img/no-image.png'),
      //),
    );
  }

  void refresh () {
    setState(() {
    });
  }

}
