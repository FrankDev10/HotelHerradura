import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hotel3/src/models/product.dart';
import 'package:hotel3/src/pages/client/orders/create/client_orders_create_controller.dart';
import 'package:hotel3/src/utils/my_colors.dart';
import 'package:hotel3/src/widgets/no_data_widget.dart';



class ClientOrdersCreatePage extends StatefulWidget {
  const ClientOrdersCreatePage({Key key}) : super(key: key);

  @override
  State<ClientOrdersCreatePage> createState() => _ClientOrdersCreatePageState();
}

class _ClientOrdersCreatePageState extends State<ClientOrdersCreatePage> {

  final ClientOrdersCreateController _con = ClientOrdersCreateController();

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
        title: const Text('Mis Reservaciones'),
      ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height * 0.20,
        child:  ListView(
          children: [
            Divider(
              color: Colors.grey[400],
              endIndent: 30, // MARGEN EN LA PARTE DERECHA
              indent: 30, // margen IZQUIERDA
            ),
            _textTotalPrice(),
            _buttonNext()
          ],
        ),
      ),
      body: _con.selectedProducts.isNotEmpty
      ? ListView(
            children: _con.selectedProducts.map((Product product) {
              return _cardProduct(product);
            }).toList(),
          )
          : const Center(child: NoDataWidget()),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30),
      height: 40,
      child: ElevatedButton(
        onPressed:_con.goToAddress,
        //_con.goToAddress,
        style: ElevatedButton.styleFrom(
            primary: MyColors.primarycolor,
            padding: const EdgeInsets.symmetric(vertical: 5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            )
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: const Text(
                  'CONTINUAR',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 80),
                height: 30,
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 27,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardProduct(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _imageProduct(product),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style:  const TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              _addOrRemoveItem(product),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              _testPrice(product),
              _iconDelete(product)
            ],
          )
        ],
      ),
    );
  }
  
  Widget _iconDelete(Product product) {
    return IconButton(
        onPressed: () {
          _con.deleteItem(product);
        },
        icon: Icon(Icons.delete, color: MyColors.primarycolorDark,)
    );
  }

  Widget _textTotalPrice() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // divide los elemntos por iguales dentro
        children: [
          const Text(
              'Total',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22
            ),
          ),

          Text(
              '${_con.total}\$',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          )
        ],
      ),
    );
  }

  Widget _testPrice(Product product) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Text(
        '${product.price * product.quantity}',
        style: TextStyle(
          color: MyColors.primarycolor,
          fontWeight: FontWeight.bold

        ),
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
      width: 100,
      height: 70,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: MyColors.primaryOpacityColor
      ),
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

  Widget _addOrRemoveItem(Product product) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            _con.removeItem(product);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              color: MyColors.primaryOpacityColor
            ),
            child: const Text('-'),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          color: MyColors.primaryOpacityColor,
          child: Text('${product?.quantity ?? 0}',),
        ),
        GestureDetector(
          onTap: () {
            _con.addItem(product);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              color: MyColors.primaryOpacityColor
            ),
            child: const Text('+'),
          ),
        ),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}
