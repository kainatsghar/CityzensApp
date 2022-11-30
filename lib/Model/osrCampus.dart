class OSRCampusModel {
  int id;
  String name;
  String code;
  String address;
  bool isActive;

  OSRCampusModel({
    this.id,
    this.name,
    this.code,
    this.address,
    this.isActive,
  });

  factory OSRCampusModel.fromJson(Map json) {
    return OSRCampusModel(
      id: json['Id'],
      name: json['Name'],
      code: json['Code'],
      address: json['Address'],
      isActive: json['IsActive'],
    );
  }
}


