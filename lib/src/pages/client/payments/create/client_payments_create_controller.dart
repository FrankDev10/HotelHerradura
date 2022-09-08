import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';

class ClientPaymentsCreateController {

  BuildContext context;
  Function refesh;
  GlobalKey<FormState> keyForm = GlobalKey();

  String cardNumber = '';
  String expireDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  Future init(BuildContext context, Function refresh) {
    this.context = context;
    refesh = refresh;
  }

  void onCreditCardModelChanged(CreditCardModel creditCardModel) {
    cardNumber = creditCardModel.cardNumber;
    expireDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    isCvvFocused = creditCardModel.isCvvFocused;
    refesh();

  }

}