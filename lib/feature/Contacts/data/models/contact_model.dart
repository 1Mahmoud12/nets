class ContactModel {
  bool? status;
  int? code;
  String? message;
  List<Data>? data;

  ContactModel({this.status, this.code, this.message, this.data});

  ContactModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  int? id;
  int? userId;
  String? phone;
  String? email;
  String? name;
  String? image;
  String? titleWork;
  String? qrCodeData;
  String? notes;
  dynamic voiceNote;
  String? location;
  String? scannedAt;
  String? createdAt;
  String? updatedAt;
  String? status;

  Data({
    this.id,
    this.userId,
    this.phone,
    this.email,
    this.name,
    this.image,
    this.titleWork,
    this.qrCodeData,
    this.notes,
    this.voiceNote,
    this.location,
    this.scannedAt,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    phone = json['phone'];
    email = json['email'];
    name = json['name'];
    image = json['image'];
    titleWork = json['title_work'];
    qrCodeData = json['qr_code_data'];
    notes = json['notes'];
    status = json['status'];
    voiceNote = json['voice_note'];
    location = json['location'];
    scannedAt = json['scanned_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['phone'] = phone;
    data['email'] = email;
    data['name'] = name;
    data['image'] = image;
    data['title_work'] = titleWork;
    data['qr_code_data'] = qrCodeData;
    data['notes'] = notes;
    data['status'] = status;
    data['voice_note'] = voiceNote;
    data['location'] = location;
    data['scanned_at'] = scannedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
