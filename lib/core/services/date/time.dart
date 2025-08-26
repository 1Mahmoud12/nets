import 'package:easy_localization/easy_localization.dart';

class DateAndTime {
  static DateTime convertTimestampToTime(int timestamp) {
    // Convert to local DateTime
    final DateTime localTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true).toLocal();
    // Format time
    final String formattedTime = DateFormat.jm('en').format(localTime);

    return localTime;
  }
}
