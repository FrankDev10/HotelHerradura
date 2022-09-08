import 'dart:convert';



Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  Address({
    this.id,
    this.idUser,
    this.address,
    this.country,
    this.cedula,
    this.arrival,
    this.hourArrival,
    this.departure,
    this.numberPeople,
    this.paymentNumber,
    this.image,
    this.description,
    //this.client,

  });

  String id;
  String idUser;
  String address;
  String country;
  String cedula;
  String arrival;
  String hourArrival;
  String departure;
  String numberPeople;
  String paymentNumber;
  String image;
  String description;
  List<Address> toList = [];
  //User client;

  //List.from(json.decode(str)).map((x) => Categorys.fromJson(Map.from(x)))).toList();
  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"] is int ? json["id"].toString() : json["id"],
    idUser: json["id_user"] is int ? json['id'].toString() : json['id'],
    //idUser: json["id_user"],
    address: json["address"] is int ? json["address"].toString() : json["address"],
    country: json["country"] is int ? json["country"].toString() : json["country"],
    //cedula: json["cedula"] is String ? double.parse(json["cedula"]) : json["cedula"],
    cedula: json["cedula"] is int ? json["cedula"].toString() : json["cedula"],
    arrival: json["arrival"] is int ? json["arrival"].toString() : json["arrival"],
    hourArrival: json["hour_arrival"] is int ? json["hour_arrival"].toString() : json["hour_arrival"],
    departure: json["departure"] is int ? json["departure"].toString() : json["departure"],
    numberPeople: json["number_people"] is int ? json["number_people"].toString() : json["number_people"],
    paymentNumber: json["paymentNumber"] is int ? json["paymentNumber"].toString() : json["paymentNumber"],
    image: json["image"],
    description: json["description"] is int ? json["description"].toString() : json["description"],
    //client: json['client'] is String ? userFromJson(json['client']) : User.fromJson(json['client'] ?? {}),
  );


  Address.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    for (var item in jsonList) {
      Address address = Address.fromJson(item);
      toList.add(address);
    }
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_user": idUser,
    "address": address,
    "country": country,
    "cedula": cedula,
    "arrival": arrival,
    "hour_arrival": hourArrival,
    "departure": departure,
    "number_people": numberPeople,
    "paymentNumber": paymentNumber,
    "image": image,
    "description": description,
  };

}
