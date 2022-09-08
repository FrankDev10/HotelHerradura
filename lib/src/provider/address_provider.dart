import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hotel3/src/api/environment.dart';
import 'package:hotel3/src/models/address.dart';
import 'package:hotel3/src/models/response_api.dart';
import 'package:hotel3/src/models/user.dart';


import 'package:http/http.dart' as http;
import 'package:path/path.dart';


class AddressProvider {

  final String _url = Environment.API_DELIVERY;
  final String _api = '/api/address';
  BuildContext context;
  User sessionUser;

  Future init(BuildContext context, User sessionUser) {
    this.context = context;
    this.sessionUser = sessionUser;
  }


  Future<List<Address>> getByUser(String idUser) async {
    try{
      Uri url = Uri.http(_url, '$_api/findByUser/$idUser');
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
     Address address = Address.fromJsonList(data);
     return address.toList;
     }
    catch (e) {
    print('Error: $e');
    return [];
    }

  }

  Future<Stream> createWithImage(Address address, File image) async {
    try{
      Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', url);

      if (image != null) {
        request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(image.openRead().cast()),
          await image.length(),
          filename: basename(image.path)
        ));
      }

      request.fields['address'] = json.encode(address);
      final response = await request.send(); //ENVIAR LA PETICION
      return response.stream.transform(utf8.decoder);
    }
    catch(e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi> create(Address address, File image) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(address);
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




}