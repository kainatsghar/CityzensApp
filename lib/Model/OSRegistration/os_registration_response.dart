import 'dart:convert';

class OSRegistrationResponse {
  int id;
  String name;
  String code;
  String address;
  bool isActive;

  OSRegistrationResponse({
    this.id,
    this.name,
    this.code,
    this.address,
    this.isActive,
  });

  factory OSRegistrationResponse.fromJson(Map json) {
    return OSRegistrationResponse(
      id: json['Id'],
      name: json['Name'],
      code: json['Code'],
      address: json['Address'],
      isActive: json['IsActive'],
    );
  }
}

  List<OSRegistrationResponse> listFromJson(String str) =>
      List<OSRegistrationResponse>.from(
          json.decode(str).map((x) => OSRegistrationResponse.fromJson(x)));