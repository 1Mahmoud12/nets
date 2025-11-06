class UserStatisticsModel {
  bool? success;
  StatisticsData? data;

  UserStatisticsModel({this.success, this.data});

  UserStatisticsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? StatisticsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class StatisticsData {
  int? numContacts;
  int? numScanQrCode;
  int? numGroups;

  StatisticsData({this.numContacts, this.numScanQrCode, this.numGroups});

  StatisticsData.fromJson(Map<String, dynamic> json) {
    numContacts = json['num_contacts'];
    numScanQrCode = json['num_scan_qr_code'];
    numGroups = json['num_groups'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['num_contacts'] = numContacts;
    data['num_scan_qr_code'] = numScanQrCode;
    data['num_groups'] = numGroups;
    return data;
  }
}
