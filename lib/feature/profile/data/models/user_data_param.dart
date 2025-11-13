class UserDataParam {
  String? firstName;
  String? lastName;
  String? email;
  String? website;
  String? zipCode;
  String? streetName;
  String? buildingNumber;
  String? streetNumber;
  String? additionalInformation;
  String? titleWork;
  List<Phones>? phones;
  List<SocialLinks>? socialLinks;

  UserDataParam({
    this.firstName,
    this.lastName,
    this.email,
    this.website,
    this.zipCode,
    this.streetName,
    this.buildingNumber,
    this.streetNumber,
    this.additionalInformation,
    this.titleWork,
    this.phones,
    this.socialLinks,
  });

  UserDataParam.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    website = json['website'];
    zipCode = json['zip_code'];
    streetName = json['street_name'];
    buildingNumber = json['building_number'];
    streetNumber = json['street_number'];
    additionalInformation = json['additional_information'];
    titleWork = json['title_work'];
    if (json['phones'] != null) {
      phones = <Phones>[];
      json['phones'].forEach((v) {
        phones!.add(Phones.fromJson(v));
      });
    }
    if (json['social_links'] != null) {
      socialLinks = <SocialLinks>[];
      json['social_links'].forEach((v) {
        socialLinks!.add(SocialLinks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    void addIfNotNull(String key, dynamic value) {
      if (value == null) return;
      if (value is String && value.isEmpty) return;
      data[key] = value;
    }

    addIfNotNull('first_name', firstName);
    addIfNotNull('last_name', lastName);
    addIfNotNull('email', email);
    addIfNotNull('website', website);
    addIfNotNull('zip_code', zipCode);
    addIfNotNull('street_name', streetName);
    addIfNotNull('building_number', buildingNumber);
    addIfNotNull('street_number', streetNumber);
    addIfNotNull('additional_information', additionalInformation);
    addIfNotNull('title_work', titleWork);

    if (phones != null && phones!.isNotEmpty) {
      data['phones'] = phones!.map((v) => v.toJson()).toList();
    }
    if (socialLinks != null && socialLinks!.isNotEmpty) {
      data['social_links'] = socialLinks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Phones {
  String? phone;
  String? type;
  bool? isPrimary;

  Phones({this.phone, this.type, this.isPrimary});

  Phones.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    type = json['type'];
    isPrimary = json['is_primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['type'] = type;
    data['is_primary'] = isPrimary;
    return data;
  }
}

class SocialLinks {
  String? platform;
  String? url;

  SocialLinks({this.platform, this.url});

  SocialLinks.fromJson(Map<String, dynamic> json) {
    platform = json['platform'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['platform'] = platform;
    data['url'] = url;
    return data;
  }
}
