class JourneyModel {
  bool? status;
  int? code;
  String? message;
  List<JourneyData>? data;

  JourneyModel({this.status, this.code, this.message, this.data});

  JourneyModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <JourneyData>[];
      json['data'].forEach((v) {
        data!.add(JourneyData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JourneyData {
  int? id;
  int? userId;
  String? name;
  String? description;
  String? address;
  String? latitude;
  String? longitude;
  String? journeyDate;
  String? createdAt;
  String? updatedAt;
  List<Persons>? persons;

  JourneyData({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.address,
    this.latitude,
    this.longitude,
    this.journeyDate,
    this.createdAt,
    this.updatedAt,
    this.persons,
  });

  JourneyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    description = json['description'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    journeyDate = json['journey_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['persons'] != null) {
      persons = <Persons>[];
      json['persons'].forEach((v) {
        persons!.add(Persons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['description'] = description;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['journey_date'] = journeyDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (persons != null) {
      data['persons'] = persons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Persons {
  int? id;
  int? journeyId;
  String? name;
  String? createdAt;
  String? updatedAt;

  Persons({this.id, this.journeyId, this.name, this.createdAt, this.updatedAt});

  Persons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    journeyId = json['journey_id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['journey_id'] = journeyId;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
