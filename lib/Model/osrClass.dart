class OSRClassModel {
  int id;
  String name;
  String code;
  bool isActive;

  OSRClassModel({
    this.id,
    this.name,
    this.code,
    this.isActive,
  });

  factory OSRClassModel.fromJson(Map json) {
    return OSRClassModel(
      id: json['Id'],
      name: json['Name'],
      code: json['Code'],
      isActive: json['IsActive'],
    );
  }
}


