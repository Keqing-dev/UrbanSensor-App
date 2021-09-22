import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class FormatDate {
  static String calendar(String? date) {
    return Jiffy(date).format("EEE MMM d yyyy");
  }

  static String clock(String? date) {
    var parsedDate = DateTime.parse(date!);

    var dateTime =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse(parsedDate.toString(), true);
    var dateLocal = dateTime.toLocal();

    return Jiffy('$dateLocal').format("HH:mm");
  }

  static String dateTime(DateTime dateTime) {
    return "${DateFormat.yMMMMd().format(dateTime)}, ${DateFormat.Hm().format(dateTime)}";
  }
}
