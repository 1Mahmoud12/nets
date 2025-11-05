class LoginModel {
  bool? status;
  int? code;
  String? message;
  Data? data;

  LoginModel({this.status, this.code, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? success;
  String? message;
  User? user;
  String? token;

  Data({this.success, this.message, this.user, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class User {
  int? id;
  String? phone;
  String? phoneVerifiedAt;
  bool? status;
  bool? sharePhoneNumber;
  bool? notifyMe;
  bool? allUserAutoAsync;
  String? createdAt;
  String? updatedAt;
  Profile? profile;
  NotificationSettings? notificationSettings;

  User({
    this.id,
    this.phone,
    this.phoneVerifiedAt,
    this.status,
    this.sharePhoneNumber,
    this.notifyMe,
    this.allUserAutoAsync,
    this.createdAt,
    this.updatedAt,
    this.profile,
    this.notificationSettings,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    phoneVerifiedAt = json['phone_verified_at'];
    status = json['status'];
    sharePhoneNumber = json['share_phone_number'];
    notifyMe = json['notify_me'];
    allUserAutoAsync = json['all_user_auto_async'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profile = json['profile'] != null ? Profile.fromJson(json['profile']) : null;
    notificationSettings = json['notification_settings'] != null ? NotificationSettings.fromJson(json['notification_settings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phone'] = phone;
    data['phone_verified_at'] = phoneVerifiedAt;
    data['status'] = status;
    data['share_phone_number'] = sharePhoneNumber;
    data['notify_me'] = notifyMe;
    data['all_user_auto_async'] = allUserAutoAsync;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    if (notificationSettings != null) {
      data['notification_settings'] = notificationSettings!.toJson();
    }
    return data;
  }
}

class Profile {
  int? id;
  int? userId;
  String? firstName;
  String? lastName;
  String? email;
  String? image;
  String? website;
  String? zipCode;
  String? streetName;
  String? buildingNumber;
  String? streetNumber;
  String? additionalInformation;
  dynamic qrCodeData;
  String? titleWork;
  String? createdAt;
  String? updatedAt;

  Profile({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.image,
    this.website,
    this.zipCode,
    this.streetName,
    this.buildingNumber,
    this.streetNumber,
    this.additionalInformation,
    this.qrCodeData,
    this.titleWork,
    this.createdAt,
    this.updatedAt,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    image = json['image'];
    website = json['website'];
    zipCode = json['zip_code'];
    streetName = json['street_name'];
    buildingNumber = json['building_number'];
    streetNumber = json['street_number'];
    additionalInformation = json['additional_information'];
    qrCodeData = json['qr_code_data'];
    titleWork = json['title_work'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['image'] = image;
    data['website'] = website;
    data['zip_code'] = zipCode;
    data['street_name'] = streetName;
    data['building_number'] = buildingNumber;
    data['street_number'] = streetNumber;
    data['additional_information'] = additionalInformation;
    data['qr_code_data'] = qrCodeData;
    data['title_work'] = titleWork;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class NotificationSettings {
  int? id;
  int? userId;
  bool? pushNotification;
  bool? smsNotification;
  bool? emailNotification;
  String? createdAt;
  String? updatedAt;

  NotificationSettings({this.id, this.userId, this.pushNotification, this.smsNotification, this.emailNotification, this.createdAt, this.updatedAt});

  NotificationSettings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    pushNotification = json['push_notification'];
    smsNotification = json['sms_notification'];
    emailNotification = json['email_notification'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['push_notification'] = pushNotification;
    data['sms_notification'] = smsNotification;
    data['email_notification'] = emailNotification;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
