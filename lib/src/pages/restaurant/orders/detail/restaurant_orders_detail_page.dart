import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hotel3/src/models/order.dart';
import 'package:hotel3/src/models/product.dart';
import 'package:hotel3/src/pages/restaurant/orders/detail/restaurant_orders_detail_controller.dart';
import 'package:hotel3/src/utils/my_colors.dart';
import 'package:hotel3/src/utils/relative_time_util.dart';
import 'package:hotel3/src/widgets/no_data_widget.dart';

class RestaurantOrdersDetailPage extends StatefulWidget {
  Order order;

  RestaurantOrdersDetailPage({
    Key key,
    @required this.order,
  }) : super(key: key);

  @override
  _RestaurantOrdersDetailPageState createState() =>
      _RestaurantOrdersDetailPageState();
}

class _RestaurantOrdersDetailPageState
    extends State<RestaurantOrdersDetailPage> {
  final RestaurantOrdersDetailController _con =
      RestaurantOrdersDetailController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orden #${_con.order?.id ?? ''}'),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 18, right: 25),
            child: Text(
              'Total: ${_con.total}\$',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 0.41,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Divider(
                color: Colors.grey[400],
                endIndent: 10, // MARGEN EN LA PARTE DERECHA
                indent: 30, // margen IZQUIERDA
              ),
              //_textData(title, content)
              //_textData('Cliente:', '${_con.order?.client?.id ?? ""} ${_con.order?.client?.name ?? ""} ${_con.order?.client?.lastname ?? ""}'),
              _textData('Cliente:',
                  '${_con?.order?.client?.name ?? ""} ${_con.order?.client?.lastname ?? ""}'),
               _textData('Correo:', '${_con.order?.client?.email ?? ""} '),
              _textData('Dirección:', _con?.order?.direccion ?? ''),
              _textData('Cedula:', _con?.order?.client?.cedula ?? ''),
              _textData('Número del comprobante de pago:',
                  '${_con.order?.number_people ?? ""} '),
              _imageVocuher(),
              _textData('Fecha de llegada:', _con?.order?.arrival ?? ''),

              _textData('Fecha de Salida:', _con?.order?.departure ?? ''),
              _textData(
                  'Número de teléfono:', _con?.order?.client?.phone ?? ''),
              _textData('Fecha de reserva:',
                  '${RelativeTimeUtil.getRelativeTime(_con.order?.timestamp ?? 0)} '), 
              Row(
                children: [
                  _con.order?.status == 'PAGADO' ? _buttonNext() : Container(),
                  const Spacer(),
                  //_buttonForm(),
                  const Spacer(),
                  _buttonCallPhone()
                ],
              )
            ],
          ),
        ),
      ),
      body: _con.order?.products?.length != null
          //body: _con.order?.products?.length > 0
          ? ListView(
              children: _con.order?.products?.map((Product product) {
                return _cardProduct(product);
              })?.toList(),
            )
          : const NoDataWidget(
              //text: 'Ningun producto agregado',
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

  Widget _buttonForm() {
    return Container(
      width: 150,
      //margin: EdgeInsets.symmetric(horizontal: 190),
      margin: const EdgeInsets.only(top: 5),
      child: ElevatedButton(
        onPressed: _con.openBottomSheet,
        //_con.goToAddress,
        style: ElevatedButton.styleFrom(
            primary: MyColors.primarycolor,
            padding: const EdgeInsets.symmetric(vertical: 3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: const Text(
                  'VERIFICAR PAGO',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonCallPhone() {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: MyColors.primaryOpacityColor),
      child: IconButton(
        onPressed: _con.call,
        icon: const Icon(
          Icons.phone,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(left: 20, top: 5),
      child: ElevatedButton(
        onPressed: _con.updateOrder,
        //_con.goToAddress,
        style: ElevatedButton.styleFrom(
            primary: MyColors.primarycolor,
            padding: const EdgeInsets.symmetric(vertical: 3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: const Text(
                  'RESERVAR',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Container(
            //     margin: EdgeInsets.only(left: 10,top: 4),
            //     height: 30,
            //     child: Icon(
            //       Icons.check_circle,
            //       color: Colors.white,
            //       size: 30,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Widget _buttonNextTerminate() {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(left: 20, top: 5),
      child: ElevatedButton(
        onPressed: _con.updateOrder,
        //_con.goToAddress,
        style: ElevatedButton.styleFrom(
            primary: MyColors.primarycolor,
            padding: const EdgeInsets.symmetric(vertical: 3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 40,
                alignment: Alignment.center,
                child: const Text(
                  'TERMINAR',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardProduct(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          _imageProduct(product),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                //product.name ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Cantidad: ${product.quantity}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
      width: 200,
      height: 110,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[200]),
      child: FadeInImage(
        image: product.image1 != null
            ? NetworkImage(product.image1)
            : const AssetImage('assets/img/pizza2.png'),
        fit: BoxFit.contain,
        fadeInDuration: const Duration(milliseconds: 50),
        placeholder: const AssetImage('assets/img/no-image.png'),
      ),
    );
  }

  Widget _imageVocuher() {
    return Container(
      //height: 300,
      margin: const EdgeInsets.only(top: 10),
      // child: Image(
      //   image: AssetImage('assets/img/voucher.jpg'),
      // ),
      child: FadeInImage(
        image: _con.order?.image != null
            ? NetworkImage(_con.order.image)
            : const AssetImage('assets/img/no-image.png'),
        fit: BoxFit.contain,
        fadeInDuration: const Duration(milliseconds: 50),
        placeholder: const AssetImage('assets/img/no-image.png'),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
