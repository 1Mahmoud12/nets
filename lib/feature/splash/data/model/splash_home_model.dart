class SplashHomeModel {
  bool? success;
  Data? data;
  String? message;

  SplashHomeModel({this.success, this.data, this.message});

  SplashHomeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  Weather? weather;
  String? liveStreamUrl;
  List<SplashScreenItems>? splashScreenItems;
  List<AdvertisementItems>? advertisementItems;
  List<Departments>? departments;

  Data({this.liveStreamUrl, this.weather, this.splashScreenItems, this.advertisementItems, this.departments});

  Data.fromJson(Map<String, dynamic> json) {
    liveStreamUrl = json['liveStreamUrl'];
    weather = json['weather'] != null ? Weather.fromJson(json['weather']) : null;
    if (json['splashScreenItems'] != null) {
      splashScreenItems = <SplashScreenItems>[];
      json['splashScreenItems'].forEach((v) {
        splashScreenItems!.add(SplashScreenItems.fromJson(v));
      });
      splashScreenItems ??= [];
      splashScreenItems!.add(SplashScreenItems(title: 'كن أول من يعلم', secondTitle: 'ابقَ على اطلاع دائم بآخر الأخبار العاجلة والمحتوى الحصري.'));
      splashScreenItems!.add(SplashScreenItems(title: 'مصمم خصيصًا لك', secondTitle: 'استمتع بتجربة مخصصة حسب اهتماماتك وتفضيلاتك.'));
      splashScreenItems!.add(SplashScreenItems(title: 'قائمة المفضلات', secondTitle: 'احفظ محتواك المفضل في قائمة خاصة للرجوع إليه لاحقًا بسهولة.'));
      splashScreenItems!.add(SplashScreenItems(title: 'التنبيهات', secondTitle: 'فعّل الإشعارات لتصلك التحديثات فور نشرها.'));
    }
    if (json['advertisementItems'] != null) {
      advertisementItems = <AdvertisementItems>[];
      json['advertisementItems'].forEach((v) {
        advertisementItems!.add(AdvertisementItems.fromJson(v));
      });
    }
    if (json['departments'] != null) {
      departments = <Departments>[];
      json['departments'].forEach((v) {
        departments!.add(Departments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (weather != null) {
      data['weather'] = weather!.toJson();
    }
    data['liveStreamUrl'] = liveStreamUrl;

    if (splashScreenItems != null) {
      data['splashScreenItems'] = splashScreenItems!.map((v) => v.toJson()).toList();
    }
    if (advertisementItems != null) {
      data['advertisementItems'] = advertisementItems!.map((v) => v.toJson()).toList();
    }
    if (departments != null) {
      data['departments'] = departments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Weather {
  String? temperature;
  String? text;
  String? icon;

  Weather({this.temperature, this.text, this.icon});

  Weather.fromJson(Map<String, dynamic> json) {
    temperature = json['temperature'];
    text = json['text'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temperature'] = temperature;
    data['text'] = text;
    data['icon'] = icon;
    return data;
  }
}

class SplashScreenItems {
  int? id;
  String? title;
  String? secondTitle;

  SplashScreenItems({this.id, this.title, this.secondTitle});

  SplashScreenItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    secondTitle = json['second_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['second_title'] = secondTitle;
    return data;
  }
}

class AdvertisementItems {
  int? id;
  String? title;
  String? slug;

  AdvertisementItems({this.id, this.title, this.slug});

  AdvertisementItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    return data;
  }
}

class Departments {
  int? id;
  String? title;

  Departments({this.title});

  Departments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}
