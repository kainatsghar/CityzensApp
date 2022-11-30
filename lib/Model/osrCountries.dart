class OSRCountriesModel {
  int id;
  String name;
  String code;
  bool isActive;

  OSRCountriesModel({
    this.id,
    this.name,
    this.code,
    this.isActive,
  });

  factory OSRCountriesModel.fromJson(Map json) {
    return OSRCountriesModel(
      id: json['Id'],
      name: json['Name'],
      code: json['Code'],
      isActive: json['IsActive'],
    );
  }
}


