import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hotel3/src/api/environment.dart';
import 'package:hotel3/src/models/response_api.dart';
import 'package:hotel3/src/models/user.dart';


import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UsersProvider {

  final String _url = Environment.API_DELIVERY;
  final String _api = '/api/users';

  BuildContext context;
  User sessionUser;
  //String token;
  // dentro del init alado del context va  , {String token}
  Future init(BuildContext context, {String token, User sessionUser}){
    this.context = context;
    this.sessionUser;
    //this.token = token;
  }

  Future<User> getById(String id) async {
    try {
      Uri url = Uri.http(_url, '$_api/findById/$id');
      Map<String, String> headers = {
        'Content-type': 'application/json',// aqui va una (,)para continuar la linea de abajo
        //'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      /*
      if (res.statusCode == 401) {// NO AUTORIZDO -- Pero me sale 500
        Fluttertoast.showToast(msg: 'Tu session expiro');
        new SharedPref().logout(context);
      }
       */

      final data = json.decode(res.body);
      User user = User.fromJson(data);
      return user;
    }
    catch(e) {
      print('Error: $e');
      return null;
    }
  }

  
 Future<ResponseApi> createWithImage(User user) async{
 
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(user);
      
      Map<String, String> headers ={
        'Content-type':'application/json'
      };

      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;

  } catch (e) {
    print('Error: $e');
    return null;
  }
 }



  /* Future<Stream> createWithImage(User user, File image) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', url);

      if(image != null) {
        request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(image.openRead().cast()),
          await image.length(),
          filename: basename(image.path)
        ));
      }

      request.fields['user'] = json.encode(user);
      final response = await request.send(); // ENVIAR LA PETICION
      return response.stream.transform(utf8.decoder);
    }
    catch(e) {
      print('Error: $e');
      return null;
    }
  }
 */
  
  
  Future<Stream> update(User user, File image) async {
    try {
      Uri url = Uri.http(_url, '$_api/update');
      final request = http.MultipartRequest('PUT', url);
      //request.headers['Authorization'] = token;

      if(image != null) {
        request.files.add(http.MultipartFile(
            'image',
            http.ByteStream(image.openRead().cast()),
            await image.length(),
            filename: basename(image.path)
        ));
      }

      request.fields['user'] = json.encode(user);
      final response = await request.send(); // ENVIAR LA PETICION

      /*
      if(response.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Tu session expiro');
        new SharedPref().logout(context);
      }
       */

      return response.stream.transform(utf8.decoder);
    }
    catch(e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi> create(User user) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(user);
      Map<String, String> headers = {
        'Content-type': 'application/json'
      };
      final response = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }
    catch(e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi> updateNotificationToken(String idUser, String token) async {
    try {
      Uri url = Uri.http(_url, '$_api/updateNotificationToken');
      String bodyParams = json.encode({
        'id': idUser,
        'notification_token': token
      });
      Map<String, String> headers = {
        'Content-type': 'application/json'
      };
      final response = await http.put(url, headers: headers, body: bodyParams);
      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }
    catch(e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi> login(String email, String password) async{
    try {
      Uri url = Uri.http(_url, '$_api/login');
      String bodyParams = json.encode({
        'email': email,
        'password': password
      });
      Map<String, String> headers = {
        'Content-type': 'application/json'
      };
      final response = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(response.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }catch(e) {
      print('Error: $e');
      return null;
    }
  }


}