import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:hotel3/src/pages/client/payments/create/client_payments_create_controller.dart';
import 'package:hotel3/src/utils/my_colors.dart';



class ClientPaymentsCreatePage extends StatefulWidget {
  const ClientPaymentsCreatePage({Key key}) : super(key: key);

  @override
  _ClientPaymentsCreatePageState createState() => _ClientPaymentsCreatePageState();
}

class _ClientPaymentsCreatePageState extends State<ClientPaymentsCreatePage> {

  final ClientPaymentsCreateController _con = ClientPaymentsCreateController();

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
        title: const Text('Pagos'),
      ),
      body: ListView(
        children: [
          CreditCardWidget(
            cardNumber: _con.cardNumber,
            expiryDate: _con.expireDate,
            cardHolderName: _con.cardHolderName,
            cvvCode: _con.cvvCode,
            showBackView: _con.isCvvFocused,
            cardBgColor: MyColors.primarycolor,
            obscureCardNumber: true,
            obscureCardCvv: true,
            width: MediaQuery.of(context).size.width,
            animationDuration: const Duration(milliseconds: 1000),
            labelCardHolder: 'NOMBRE Y APELLIDO',
          ),
          CreditCardForm(
            formKey: _con.keyForm, // Required
            onCreditCardModelChange: _con.onCreditCardModelChanged, // Required
            themeColor: Colors.red,
            obscureCvv: true,
            obscureNumber: true,
            cardNumberDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Número de la tarjeta',
              hintText: 'XXXX XXXX XXXX XXXX',
            ),
            expiryDateDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Fecha de Expiración',
              hintText: 'XX/XX',
            ),
            cvvCodeDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'CVV',
              hintText: 'XXX',
            ),
            cardHolderDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nombre del titular',
            ),
          ),
          _documentInfo(),
          _buttonNext()
        ],
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 50,
      child: ElevatedButton(
        onPressed: () {},
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
                  Icons.arrow_forward_ios,
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

  Widget _documentInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Material(
              elevation: 2.0,
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DropdownButton(
                        underline: Container(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_drop_down_circle,
                            color: MyColors.primarycolor,
                          ),
                        ),
                        elevation: 3,
                        isExpanded: true,
                        hint: const Text(
                          'C.C',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16
                          ),
                        ),
                        items: const [],
                        value: '',
                        onChanged: (option) {
                          setState(() {
                            print('Rehckdjhvdf $option');
                            //
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          const Flexible(
            flex: 4,
            child: TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Número de documento'
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems() {
    List<DropdownMenuItem<String>> list = [];
        list.add(DropdownMenuItem(
            child: Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: FadeInImage(),
                )
              ],
            )
        )
        );
  }

  void refresh() {
    setState(() {});
  }

}
