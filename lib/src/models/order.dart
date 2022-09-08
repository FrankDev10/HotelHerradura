import 'dart:convert';

import 'package:hotel3/src/models/address.dart';
import 'package:hotel3/src/models/product.dart';
import 'package:hotel3/src/models/user.dart';


Order orderFromJson(String str) => Order.fromJson(json.decode(str));
//Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  String id;
  String idClient;
  String idAddress;
  String status;
  int timestamp;
  List<Product> products = [];
  List<Order> toList = [];
  User client;
  Address address;
  String direccion;
  String cedula;
  String phone;
  String arrival;
  String departure;
  String number_people;
  String description;
  String image;
  int hour_arrival;
  //Address  formulario;

  Order({
    this.id,
    this.idClient,
    this.idAddress,
    this.status,
    this.timestamp,
    this.products,
    this.client,
    this.phone,
    this.address,
    this.direccion,
    this.cedula,
    this.arrival,
    this.departure,
    this.number_people,
    this.description,
    this.image,
    this.hour_arrival,
    //this.listadress,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"] is int ? json["id"].toString() : json["id"],
        idClient: json["id_client"] is int
            ? json["id_client"].toString()
            : json["id_client"],
        idAddress: json["id_address"] is int
            ? json["id_address"].toString()
            : json["id_address"],
        status:
            json["status"] is int ? json["status"].toString() : json["status"],
        timestamp: json["timestamp"] is String
            ? int.parse(json["timestamp"])
            : json["timestamp"],
        products: json["products"] != null
            ? List<Product>.from(
                    json["products"].map((model) => Product.fromJson(model))) ??
                []
            : [],
        //address: json["listadress"] != null ? List<Address>.from(json["listadress"].map((model) => Address.fromJson(model))) ?? [] : [],

        //client: json["client"] != null ? List<Product>.from(json["products"].map((model) => Product.fromJson(model))) ?? [] : [],

        client: json["client"] is String
            ? userFromJson(json["client"])
            : User.fromJson(json["client"] ?? {}),
        //address: json["address"] is String ? addressFromJson(json["address"]) : Address.fromJson(json["address"] ?? {}),
        direccion: json["direccion"] is int
            ? json["direccion"].toString()
            : json["direccion"],
        cedula:
            json["cedula"] is int ? json["cedula"].toString() : json["cedula"],
        arrival: json["arrival"] is int
            ? json["arrival"].toString()
            : json["arrival"],
        departure: json["departure"] is int
            ? json["departure"].toString()
            : json["departure"],
        number_people: json["number_people"] is int
            ? json["number_people"].toString()
            : json["number_people"],

        phone: json["phone"] is int ? json["phone"].toString() : json["phone"],

        image: json["image"],
        description: json["description"] is int
            ? json["description"].toString()
            : json["description"],
        hour_arrival: json["hour_arrival"] is int
            ? json["hour_arrival"].toString()
            : json["hour_arrival"],
        //hour_arrival: json["hour_arrival"] is String ? int.parse(json["hour_arrival"]) : json["hour_arrival"]
      );

  Order.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      Order order = Order.fromJson(item);
      //print('hola direccion ${order.direccion}');
      toList.add(order);
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_client": idClient,
        "id_address": idAddress,
        "status": status,
        "timestamp": timestamp,
        "products": products,
        "client": client,
        "phone": phone,
        "address": address,
        "direccion": direccion,
        "cedula": cedula,
        "arrival": arrival,
        "departure": departure,
        "number_people": number_people,
        "description": description,
        "image": image,
        "hour_arrival": hour_arrival,
        //"listadress":listadress,
      };
}
