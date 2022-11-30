class OSRCitiesModel {
  int id;
  String name;
  String code;
  bool isActive;

  OSRCitiesModel({
    this.id,
    this.name,
    this.code,
    this.isActive,
  });

  factory OSRCitiesModel.fromJson(Map json) {
    return OSRCitiesModel(
      id: json['Id'],
      name: json['Name'],
      code: json['Code'],
      isActive: json['IsActive'],
    );
  }
}


