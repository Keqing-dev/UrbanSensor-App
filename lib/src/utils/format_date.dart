import 'package:jiffy/jiffy.dart';

class FormatDate {
  static String calendar(String? date) {
    return Jiffy(date).format("EEE MMM d yyyy");
  }

  static String clock(String? date) {

    var parsedDate = DateTime.parse(date!).toUtc();

    return Jiffy(parsedDate).format("hh:mm");
  }
}
