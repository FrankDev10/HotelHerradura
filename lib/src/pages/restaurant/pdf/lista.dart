import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hotel3/src/models/order.dart';
import 'package:hotel3/src/pages/restaurant/pdf/lista_controller.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';


class Lista extends StatefulWidget {
  const Lista({Key key}) : super(key: key);

  @override
  State<Lista> createState() => _ListaState();
}



class _ListaState extends State<Lista> {
  ListExcelController con = ListExcelController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Generar Reporte'),),
        body: Container(
          child: Center(
            child: GestureDetector(
              onTap: createExel,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20)
                ),
                //color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/img/excel.png', fit: BoxFit.cover,),
                )
                /* child: RaisedButton(
                  child: Text('presion'),
                  onPressed: createExel,
                ), */
              ),
            ),
          ),
        )
       );
  }

  Future<void> createExel() async {
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];


    final Range range9 = sheet.getRangeByName('A1:G1');
    range9.cellStyle.backColor = '#36DFE4';
    sheet.getRangeByName('A1').setText('NOMBRES');
    sheet.getRangeByName('B1').setText('APELLIDO');
    sheet.getRangeByName('C1').setText('DIRECCIÓN');
    sheet.getRangeByName('D1').setText('FECHA DE INGRESO');
    sheet.getRangeByName('E1').setText('FECHA DE SALIDA');
    sheet.getRangeByName('F1').setText('DESCRIPCIÓN');
    sheet.getRangeByName('G1').setText('NOMBRE HABITACIÓN');



    sheet.getRangeByName('A1').columnWidth = 17.82;
    sheet.getRangeByName('B1').columnWidth = 17.82;
    sheet.getRangeByName('C1').columnWidth = 15.82;
    sheet.getRangeByName('D1').columnWidth = 23.82;
    sheet.getRangeByName('E1').columnWidth = 23.82;
    sheet.getRangeByName('F1').columnWidth = 35.82;
    sheet.getRangeByName('G1').columnWidth = 19.82;

    Container(
        child: con.listOrder.length != null ?? '' 
            ? ListView(
                children: con.listOrder.map((Order user) {
              

                for (int i = 0; i <= user.id.length; i++) {
                  if (i > 0) {
                    sheet.insertRow(i);

                    sheet.getRangeByName('A1').setText(user.client.name);
                    sheet.getRangeByName('B1').setText(user.client.lastname);
                    sheet.getRangeByName('C1').setText(user.direccion);
                    sheet.getRangeByName('D1').setText(user.arrival);
                    sheet.getRangeByName('E1').setText(user.departure);
                    sheet.getRangeByName('F1').setText(user.description);
                    sheet.getRangeByName('G1').setText(user.products[0].name);
                   
                  }
                }
              }).toList())
            : Container(child: const Text('BACIO')));

    /* final Range range9 = sheet.getRangeByName('A1:F1');
    range9.cellStyle.backColor = '#36DFE4';
    sheet.getRangeByName('A1').setText('NOMBRES');
    sheet.getRangeByName('B1').setText('APELLIDO');
    sheet.getRangeByName('C1').setText('DIRECCIÓN');
    sheet.getRangeByName('D1').setText('FECHA DE INGRESO');
    sheet.getRangeByName('E1').setText('FECHA DE SALIDA');
    sheet.getRangeByName('F1').setText('DESCRIPCIÓN');
    sheet.getRangeByName('G1').setText('NOMBRE HABITACIÓN'); */

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationDocumentsDirectory()).path;
    final String fileName = '$path/Output.xlsx';
    final File file = File(fileName);

    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }

  void refresh() {
    setState(() {});
  }
}
