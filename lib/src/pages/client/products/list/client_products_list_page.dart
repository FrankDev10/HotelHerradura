import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hotel3/src/models/category.dart';
import 'package:hotel3/src/models/product.dart';
import 'package:hotel3/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:hotel3/src/utils/my_colors.dart';
import 'package:hotel3/src/widgets/no_data_widget.dart';

class ClientProductsListPage extends StatefulWidget {
  const ClientProductsListPage({Key key}) : super(key: key);

  @override
  _ClientProductsListPageState createState() => _ClientProductsListPageState();
}

class _ClientProductsListPageState extends State<ClientProductsListPage> {
  final ClientProductsListController _con = ClientProductsListController();

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
    return DefaultTabController(
      length: _con.categories?.length,
      child: Scaffold(
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(170),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: [_shoppingBag()],
            flexibleSpace: Column(
              children: [
                const SizedBox(height: 40),
                _menuDrawer(),
                const SizedBox(
                  height: 20,
                ),
                _textFieldSearch()
              ],
            ),
            bottom: TabBar(
              indicatorColor: MyColors.primarycolor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              isScrollable: true,
              tabs: List<Widget>.generate(_con.categories.length, (index) {
                return Tab(
                  child: Text(_con.categories[index].name ?? ''),
                );
              }),
            ),
          ),
        ),
        drawer: _drawer(),
        body: TabBarView(
          children: _con.categories.map((
            Category category,
          ) {
            return FutureBuilder(
              future: _con.getProducts(category.id, _con.productName),
              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isNotEmpty) {
                    return GridView.builder(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1, childAspectRatio: 1),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (_, index) {
                          return _cardProduct(snapshot.data[index]);
                        });
                  } else {
                    return const NoDataWidget();
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _cardProduct(Product product) {
    return GestureDetector(
      onTap: () {
        _con.openBottomSheet(product);
      },
      child: Container(
        height: 250,
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Card(
          elevation: 3.0,
          margin: const EdgeInsets.only(bottom: 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment
                    .start, //esta funcion los textos se ubican en la parte izquiera de la pantalla
                children: [
                  SizedBox(
                    //margin: EdgeInsets.only(top: 0),
                    height: 200,
                    //margin: EdgeInsets.only(top: 1),
                    //width: MediaQuery.of(context).size.width * 0.45,
                    width: 400,
                    //padding: EdgeInsets.all(0),
                    child: FadeInImage(
                      image: product.image1 != null
                          ? NetworkImage(product.image1)
                          : const AssetImage('assets/img/pizza2.png'),
                      fit: BoxFit.cover,
                      // el fit cover me ayuda a que se posiscione en todo el container es mejor este
                      fadeInDuration: const Duration(milliseconds: 50),
                      placeholder: const AssetImage('assets/img/no-image.png'),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),

                    height: 30, //altura de la imagen dentreo del cardview
                    child: Text(
                      product.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NimbusSans'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: Text(
                            '${product.price ?? 0}\$',
                            style: TextStyle(
                                fontSize: 22,
                                color: MyColors.primarycolorDark,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NimbusSans'),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 200,
                          //margin: EdgeInsets.only(left: 5),
                          height: 40,
                          decoration: BoxDecoration(
                              color: MyColors.primarycolor,
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                                //bottomLeft: Radius.circular(15), // redondea la parte inferior izquiera del cuadro
                                //topRight: Radius.circular(20) // redondea la parte superior derecha  del cuadro
                              )),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _shoppingBag() {
    return GestureDetector(
      onTap: _con.goToOrderCreatePage,
      child: Stack(
        // UN ELEMENTO ENCIMA DEL OTRO ( STACK)
        children: [
          Container(
            margin: const EdgeInsets.only(right: 15, top: 13),
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
            ),
          ),
          Positioned(
              right: 16,
              top: 15,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(30))),
              ))
        ],
      ),
    );
  }

  Widget _textFieldSearch() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: _con.onChangeText,
        decoration: InputDecoration(
            hintText: 'Buscar',
            suffixIcon: Icon(Icons.search, color: Colors.grey[400]),
            hintStyle: TextStyle(fontSize: 17, color: Colors.grey[500]),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.grey[300])),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.grey[300])),
            contentPadding: const EdgeInsets.all(15)),
      ),
    );
  }

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/img/menu.png',
          width: 20,
          height: 20,
        ),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: MyColors.primarycolor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_con.user?.name ?? ''} ${_con.user?.lastname ?? ''}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                  Text(
                    _con.user?.email ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                    maxLines: 1,
                  ),
                  Text(
                    _con.user?.phone ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                    maxLines: 1,
                  ),
                  Container(
                    height: 60,
                    margin: const EdgeInsets.only(top: 10),
                    child: FadeInImage(
                      image: _con.user?.image != null
                          ? NetworkImage(_con.user?.image)
                          : const AssetImage('assets/img/no-image.png'),
                      fit: BoxFit.contain,
                      fadeInDuration: const Duration(milliseconds: 50),
                      placeholder: const AssetImage('assets/img/no-image.png'),
                    ),
                  )
                ],
              )),
          ListTile(
            onTap: _con.goToUpdatePage,
            title: const Text('Editar perfil'),
            trailing: const Icon(Icons.edit_outlined),
          ),
          /* ListTile(
            onTap: _con.goToOrderCreatePage,
            title: Text('Mis pedidos'),
            trailing: Icon(Icons.shopping_cart_outlined),
          ), */
          _con.user != null
              ? _con.user.roles.length > 1
                  ? ListTile(
                      onTap: _con.goToRoles,
                      title: const Text('Seleccionar rol'),
                      trailing: const Icon(Icons.person_outline),
                    )
                  : Container()
              : Container(),
          ListTile(
            onTap: _con.logout,
            title: const Text('Cerrar sesión'),
            trailing: const Icon(Icons.power_settings_new),
          )
        ],
      ),
    );
  }

  void refresh() {
    setState(() {
      // CTRL+ S
    });
  }
}
