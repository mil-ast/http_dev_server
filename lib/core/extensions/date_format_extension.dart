import 'package:intl/intl.dart';

final _dtFormat = DateFormat.yMMMMd();
final _timeFormat = DateFormat.Hms();

extension NumberFormatExtension on DateTime {
  String yMMMMd() {
    return _dtFormat.format(this);
  }

  String hms() {
    return _timeFormat.format(this);
  }
}
