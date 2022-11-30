class OSRSessionModel {
  int id;
  String name;
  String code;
  bool isActive;

  OSRSessionModel({
    this.id,
    this.name,
    this.code,
    this.isActive,
  });

  factory OSRSessionModel.fromJson(Map json) {
    return OSRSessionModel(
      id: json['Id'],
      name: json['Name'],
      code: json['Code'],
      isActive: json['IsActive'],
    );
  }
}


