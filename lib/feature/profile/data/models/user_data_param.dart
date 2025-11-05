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
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;  
    data['website'] = website;
    data['zip_code'] = zipCode;
    data['street_name'] = streetName;
    data['building_number'] = buildingNumber;
    data['street_number'] = streetNumber;
    data['additional_information'] = additionalInformation;
    data['title_work'] = titleWork;
    if (phones != null) {
      data['phones'] = phones!.map((v) => v.toJson()).toList();
    }
    if (socialLinks != null) {
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
