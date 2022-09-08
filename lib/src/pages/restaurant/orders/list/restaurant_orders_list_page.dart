import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hotel3/src/models/order.dart';
import 'package:hotel3/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';
import 'package:hotel3/src/utils/my_colors.dart';
import 'package:hotel3/src/utils/relative_time_util.dart';
import 'package:hotel3/src/widgets/no_data_widget.dart';



class RestaurantOrdersListPage extends StatefulWidget {
  const RestaurantOrdersListPage({Key key}) : super(key: key);

  @override
  State<RestaurantOrdersListPage> createState() => _RestaurantOrdersListPageState();
}

class _RestaurantOrdersListPageState extends State<RestaurantOrdersListPage> {

  final RestaurantOrdersListController _con = RestaurantOrdersListController();

  //Address get address => null;

  Order order;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context,refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _con.status?.length,
      child: Scaffold(
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            flexibleSpace: Column(
              children: [
                const SizedBox(height: 40),
                _menuDrawer()
              ],
            ),
            bottom: TabBar(
              indicatorColor: MyColors.primarycolor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              isScrollable: true,
              tabs: List<Widget>.generate(_con.status.length, (index) {
                return Tab(
                  child: Text(_con.status[index] ?? ''),
                );
              }),
            ),
          ),
        ),
        drawer: _drawer(),
        body: TabBarView(
          children: _con.status.map((String status) {
            //return _cardOrder(null);
            return FutureBuilder(
              future: _con.getOrders(status),
              builder: (context, AsyncSnapshot<List<Order>> snapshot) {

                if (snapshot.hasData) {

                  if (snapshot.data.isNotEmpty) {
                    return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (_, index) {
                          return _cardOrder(snapshot.data[index]);
                        }
                    );
                  }
                  else {
                    return const NoDataWidget();
                  }

                }
                else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _cardOrder(Order order) {
    return GestureDetector(
      onTap: () {
        _con.openBottomSheet(order);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 155,
        child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          ),
          child: Stack(
            children: [
              Positioned(
                  child: Container(
                    height: 30,
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                      color: MyColors.primarycolor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )
                    ),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                          'Orden #${order.id}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontFamily: 'NimbusSans'
                        ),
                      ),
                    ),
                  )
              ),
              Container(
                margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        'Cliente: ${order.client?.name ?? ''} ${order.client?.lastname ?? ''}',
                        //'Pedido: ${RelativeTimeUtil.getRelativeTime(_con.order?.timestamp ?? 0)}' ,
                        style: const TextStyle(
                            fontSize: 13
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        //'Cliente: ${order.address.description }',
                        'Correo: ${order.client.email}',
                        style: const TextStyle(
                            fontSize: 13
                        ),
                        maxLines: 1,
                      ),
                    ),
                    // Container(
                    //   alignment: Alignment.centerLeft,
                    //   margin: EdgeInsets.symmetric(vertical: 5),
                    //   child: Text(
                    //     'Direccion: ${order.formulario.description}',
                    //     style: TextStyle(
                    //         fontSize: 13
                    //     ),
                    //   ),
                    // ),
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: const Text(
                        'Pedido: 2022-08-17',style: TextStyle(
                            fontSize: 13
                        ),
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

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/img/menu.png', width: 20, height: 20,),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  color: MyColors.primarycolor
              ) ,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_con.user?.name ?? ''} ${_con.user?.lastname ?? ''}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    _con.user?.email ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    _con.user?.phone ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                    ),
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
              )
          ),
          ListTile(
            onTap: _con.goToCategoryCreate,
            title: const Text('Crear categoria'),
            trailing: const Icon(Icons.list_alt),
          ),
          ListTile(
            onTap: _con.goToProductCreate,
            title: const Text('Crear habitación'),
            trailing: const Icon(Icons.local_hotel_sharp),
          ),

          ListTile(
            onTap: _con.listaHabitacion,
            title: const Text('Lista de Habitación'),
            trailing: const Icon(Icons.home),
          ),
          ListTile(
            onTap: _con.irPdf,
            title: const Text('Reporte'),
            trailing: const Icon(Icons.home),
          ),
          _con.user != null ?
          _con.user.roles.length > 1?
          ListTile(
            onTap:_con.goToRoles,
            title: const Text('Seleccionar rol'),
            trailing: const Icon(Icons.person_outline),
          ) : Container() : Container(),
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
    setState(() {});
  }

}
