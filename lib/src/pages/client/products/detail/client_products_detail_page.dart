import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:hotel3/src/models/product.dart';
import 'package:hotel3/src/pages/client/products/detail/client_products_detail_controller.dart';
import 'package:hotel3/src/utils/my_colors.dart';



class ClientsProductsDetailPage extends StatefulWidget {

  Product product;

  ClientsProductsDetailPage({Key key, @required this.product}) : super(key: key);

  @override
  State<ClientsProductsDetailPage> createState() => _ClientsProductsDetailPageState();
}

class _ClientsProductsDetailPageState extends State<ClientsProductsDetailPage> {

  final ClientsProductsDetailController _con = ClientsProductsDetailController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.product);
    });
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.97,
      child: Column(
        children: [
          _imageSlideshow(),
          _textName(),
          _textDescription(),
          const Spacer(),
          _addOrRemoveItem(),
          _standarDelivery(),
          _buttonShoppingBag()
        ],
      ),
    );
  }

  Widget _textDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(right: 30, left: 30, top: 17),
      child: Text(
        _con.product?.description ?? '',
        style:  TextStyle(
          fontSize: 17,
          color: MyColors.primarycolorDark
      ),
      ),
    );
  }

  Widget _textName() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(right: 30, left: 30, top: 35),
      child: Text(
        _con.product?.name ?? '',
        style:  const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _buttonShoppingBag() {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
      child: ElevatedButton(
        onPressed: _con.addToBag,
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
                  'AÑADIR A LA CESTA',
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
                margin: const EdgeInsets.only(left: 50,top: 5),
                height: 35,
                child: Image.asset('assets/img/bag_shop.png'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _standarDelivery() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          Image.asset(
            'assets/img/buy-shopping-store.png',
            height: 17,
          ),
          const SizedBox(width: 7,), //SEPARA LOS ELEMENTOS CON PIXELES
          const Text(
            'Reserva Standar',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green
            ),
          )
        ],
      ),
    );
  }

  Widget _addOrRemoveItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        children: [
          IconButton(
              onPressed: _con.addItem,
              icon: Icon(Icons.add_circle_outline,
              color: MyColors.primarycolor,
              size: 30,
              )
          ),
          Text(
            '${_con.counter}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: MyColors.primarycolorDark,
            ),
          ),
          IconButton(
              onPressed: _con.removeItem,
              icon: const Icon(Icons.remove_circle_outline,
                color: Colors.red,
                size: 30,
              )
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Text(
              '${_con.productPrice ?? 0}\$',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget _imageSlideshow() {
    return Stack(
      children: [
        ImageSlideshow(
          width: double.infinity, //OCUPA TODO EL ANCHO DE LA IMAGEN
          // el MEDIAQUERY ES PARA LOS DIFERENTES DIMENSIONES DE LOS TELEFONOS
          height: MediaQuery.of(context).size.height * 0.4 ,
          //height: 200,
          initialPage: 0,
          indicatorColor: MyColors.primarycolor,
          indicatorBackgroundColor: Colors.grey,
          children: [
            FadeInImage(
              image: _con.product?.image1 != null
                  ? NetworkImage(_con.product.image1)
                  : const AssetImage('assets/img/pizza2.png'),
              fit: BoxFit.cover, // o tambien puede ser fill, pero mejor cover
              fadeInDuration: const Duration(milliseconds: 50),
              placeholder: const AssetImage('assets/img/no-image.png'),
            ),FadeInImage(
              image: _con.product?.image2 != null
                  ? NetworkImage(_con.product.image2)
                  : const AssetImage('assets/img/pizza2.png'),
              fit: BoxFit.cover,// o tambien puede ser fill, pero mejor cover
              fadeInDuration: const Duration(milliseconds: 50),
              placeholder: const AssetImage('assets/img/no-image.png'),
            ),FadeInImage(
              image: _con.product?.image3 != null
                  ? NetworkImage(_con.product.image3)
                  : const AssetImage('assets/img/pizza2.png'),
              fit: BoxFit.cover,// o tambien puede ser fill, pero mejor cover
              fadeInDuration: const Duration(milliseconds: 50),
              placeholder: const AssetImage('assets/img/no-image.png'),
            ),
          ],
          onPageChanged: (value) {
            print('Page changed: $value');
          },
          autoPlayInterval: 10000,
            isLoop: true,
        ),
        Positioned(
          left: 10,
            top: 5,
            child: IconButton(
              onPressed: _con.close,
              icon: Icon(
                  Icons.arrow_back_ios,
                color: MyColors.primarycolor,
              ),
            )
        )
      ],
    );
  }

  void refresh() {
    setState(() {
  });}
}
