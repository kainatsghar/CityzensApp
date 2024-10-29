class EyeOnYourChildRequest {
  int? id;

  EyeOnYourChildRequest({
    this.id,
  });
  EyeOnYourChildRequest.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['Id'] = id;
    return data;
  }
}
