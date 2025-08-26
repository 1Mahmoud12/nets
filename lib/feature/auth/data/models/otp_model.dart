class OtpModel {
  OtpModel({this.success, this.message, this.data});

  OtpModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'];
  }

  bool? success;
  String? message;
  num? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['data'] = data;

    return map;
  }
}
