import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hotel3/src/api/environment.dart';
import 'package:hotel3/src/models/address.dart';
import 'package:hotel3/src/models/order.dart';
import 'package:hotel3/src/models/response_api.dart';
import 'package:hotel3/src/models/user.dart';
import 'package:http/http.dart' as http;


class OrdersProvider {

  final String _url = Environment.API_DELIVERY;
  final String _api = '/api/orders';
  BuildContext context;
  User sessionUser;
  Address address;

  Future init(BuildContext context, User sessionUser) {
    this.context = context;
    this.sessionUser = sessionUser;
    //this.address = address;
  }


Future<List<Order>> ListaExcel() async {
    try{
      Uri url = Uri.http(_url, '$_api/lista');
      Map<String, String> headers = {
        'Content-type': 'application/json'
        //'Authorization': sessionUser.sessionToken
      };
      final response = await http.get(url, headers: headers);
      /*
      if(res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Session expirada');
        new SharedPref().logout(context, sessionUser.id);
      }
       */
      final data = json.decode(response.body);
      Order product = Order.fromJsonList(data);
      return product.toList;
    }
    catch (e) {
      print('Error: $e');
      return [];
    }
  }


  Future<Object> getByStatus(String status) async {
    try{
      Uri url = Uri.http(_url, '$_api/findByStatus/$status');
      Map<String, String> headers = {
        'Content-type': 'application/json'
        //'Authorization': sessionUser.sessionToken
      };
      final response = await http.get(url, headers: headers);
      /*
      if(res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Session expirada');
        new SharedPref().logout(context, sessionUser.id);
      }
       */
      final data = json.decode(response.body);
      Order order = Order.fromJsonList(data);
      return order.toList;
    }
    catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<ResponseApi> create(Order order) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json'
        //'Authorization': sessionUser.sessionToken
      };
      final response = await http.post(url, headers: headers, body: bodyParams);
      /*
      if(res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Session expirada');
        new SharedPref().logout(context, sessionUser.id);
      }
       */

      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }
    catch(e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi> updateToInUse(Order order) async {
    try {
      Uri url = Uri.http(_url, '$_api/updateToInUse');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json'
        //'Authorization': sessionUser.sessionToken
      };
      final response = await http.put(url, headers: headers, body: bodyParams);
      /*
      if(res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Session expirada');
        new SharedPref().logout(context, sessionUser.id);
      }
       */

      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }
    catch(e) {
      print('Error: $e');
      return null;
    }
  }


  Future<ResponseApi> updateToTerminate(Order order) async {
    try {
      Uri url = Uri.http(_url, '$_api/updateToTerminate');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json'
        //'Authorization': sessionUser.sessionToken
      };
      final response = await http.put(url, headers: headers, body: bodyParams);
      /*
      if(res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Session expirada');
        new SharedPref().logout(context, sessionUser.id);
      }
       */

      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }
    catch(e) {
      print('Error: $e');
      return null;
    }
  }

}