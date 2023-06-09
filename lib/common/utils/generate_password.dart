import 'dart:math';

String generatePassword() {
  String upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  String lowerCase = "abcdefghijklmnopqrstuvwxyz";
  String numbers = "0123456789";
  String specialCharacters = "#?!@\$%^&*-";

  RegExp exp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$');
  String password;
  do {
    password = "";
    password += upperCase[Random().nextInt(upperCase.length)];
    password += lowerCase[Random().nextInt(lowerCase.length)];
    password += numbers[Random().nextInt(numbers.length)];
    password += specialCharacters[Random().nextInt(specialCharacters.length)];
    for (int i = 0; i < 4; i++) {
      int randomSet = (Random().nextInt(4));
      if (randomSet == 0) {
        password += upperCase[Random().nextInt(upperCase.length)];
      } else if (randomSet == 1) {
        password += lowerCase[Random().nextInt(lowerCase.length)];
      } else if (randomSet == 2) {
        password += numbers[Random().nextInt(numbers.length)];
      } else {
        password +=
            specialCharacters[Random().nextInt(specialCharacters.length)];
      }
    }
  } while (!exp.hasMatch(password));
  return password;
}
