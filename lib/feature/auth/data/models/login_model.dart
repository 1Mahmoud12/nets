class LoginModel {
  bool? success;
  String? message;
  Data? data;

  LoginModel({this.success, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? email;
  String? authKey;
  String? passwordResetToken;
  String? registrationIp;
  int? emailConfirmed;
  String? confirmationToken;
  String? firstName;
  String? lastName;
  String? phone;
  String? avatar;
  int? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  DeviceInfo? deviceInfo;

  Data({
    this.id,
    this.email,
    this.authKey,
    this.passwordResetToken,
    this.registrationIp,
    this.emailConfirmed,
    this.confirmationToken,
    this.firstName,
    this.lastName,
    this.avatar,
    this.phone,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.deviceInfo,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    authKey = json['auth_key'];
    passwordResetToken = json['password_reset_token'];
    registrationIp = json['registration_ip'];
    emailConfirmed = json['email_confirmed'];
    confirmationToken = json['confirmation_token'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    avatar = json['avatar'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deviceInfo = json['device_info'] != null ? DeviceInfo.fromJson(json['device_info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['avatar'] = avatar;
    data['auth_key'] = authKey;
    data['password_reset_token'] = passwordResetToken;
    data['registration_ip'] = registrationIp;
    data['email_confirmed'] = emailConfirmed;
    data['confirmation_token'] = confirmationToken;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (deviceInfo != null) {
      data['device_info'] = deviceInfo!.toJson();
    }
    return data;
  }
}

class DeviceInfo {
  int? id;
  int? visitorId;
  String? deviceId;
  String? deviceType;
  String? deviceToken;
  String? deviceOs;
  String? deviceVersion;
  String? createdAt;
  String? updatedAt;

  DeviceInfo({
    this.id,
    this.visitorId,
    this.deviceId,
    this.deviceType,
    this.deviceToken,
    this.deviceOs,
    this.deviceVersion,
    this.createdAt,
    this.updatedAt,
  });

  DeviceInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    visitorId = json['visitor_id'];
    deviceId = json['device_id'];
    deviceType = json['device_type'];
    deviceToken = json['device_token'];
    deviceOs = json['device_os'];
    deviceVersion = json['device_version'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['visitor_id'] = visitorId;
    data['device_id'] = deviceId;
    data['device_type'] = deviceType;
    data['device_token'] = deviceToken;
    data['device_os'] = deviceOs;
    data['device_version'] = deviceVersion;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
