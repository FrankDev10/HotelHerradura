import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hotel3/src/models/product.dart';
import 'package:hotel3/src/pages/restaurant/lista_habitaciones/listahabitacion_controller.dart';
import 'package:hotel3/src/widgets/no_data_widget.dart';



class ListaHabiatcion extends StatefulWidget {
  const ListaHabiatcion({Key key}) : super(key: key);

  @override
  State<ListaHabiatcion> createState() => _ListaHabiatcionState();
}

class _ListaHabiatcionState extends State<ListaHabiatcion> {
  final ListaHabitacionController _con = ListaHabitacionController();


   @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
       body: _con.listHOTEL.isNotEmpty
          ? ListView(
              children: _con.listHOTEL.map((Product user) {
             return ListTile(
              
              title: Text( user.name ?? '',),
              //subtitle: Text(user.price ?? ''),
              trailing: botonDelete(user.id),
            );
            }).toList())
          : const Center(
            child: NoDataWidget(),
          ),
    );
     
     
  }

  Widget botonDelete(String id) {
    return Container(
      child: IconButton(
          onPressed: () {
            _con.deleteItem(id);
            print('eliminaddo.......... $id');
          },
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          )),
    );
  }  
   void refresh(){
  setState(() { });
  }
}