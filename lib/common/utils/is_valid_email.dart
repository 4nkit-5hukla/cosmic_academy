import 'package:intl/intl.dart';

bool isValidEmail(String email) => RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    .hasMatch(email);

bool isDate(String input, String format) {
  try {
    DateFormat(format).parseStrict(input);
    //print(d);
    return true;
  } catch (e) {
    //print(e);
    return false;
  }
}
