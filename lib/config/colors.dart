import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Map<int, Color> primaryColors = {
  50: Color(0x182A5C99),
  100: Color(0x332A5C99),
  200: Color(0x4B2A5C99),
  300: Color(0x662A5C99),
  400: Color(0x7E2A5C99),
  500: Color(0x992A5C99),
  600: Color(0xB12A5C99),
  700: Color(0xCC2A5C99),
  800: Color(0xE42A5C99),
  900: Color(0xFF2A5C99),
};

const Map<int, Color> secondaryColors = {
  50: Color(0x18EAC43D),
  100: Color(0x33EAC43D),
  200: Color(0x4BEAC43D),
  300: Color(0x66EAC43D),
  400: Color(0x7EEAC43D),
  500: Color(0x99EAC43D),
  600: Color(0xB1EAC43D),
  700: Color(0xCCEAC43D),
  800: Color(0xE4EAC43D),
  900: Color(0xFFEAC43D),
};

const Map<int, Color> b1Colors = {
  50: Color(0x1814C0CC),
  100: Color(0x3314C0CC),
  200: Color(0x4B14C0CC),
  300: Color(0x6614C0CC),
  400: Color(0x7E14C0CC),
  500: Color(0x9914C0CC),
  600: Color(0xB114C0CC),
  700: Color(0xCC14C0CC),
  800: Color(0xE414C0CC),
  900: Color(0xFF14C0CC),
};

const Map<int, Color> b2Colors = {
  50: Color(0x18A6CD4E),
  100: Color(0x33A6CD4E),
  200: Color(0x4BA6CD4E),
  300: Color(0x66A6CD4E),
  400: Color(0x7EA6CD4E),
  500: Color(0x99A6CD4E),
  600: Color(0xB1A6CD4E),
  700: Color(0xCCA6CD4E),
  800: Color(0xE4A6CD4E),
  900: Color(0xFFA6CD4E),
};

const Map<int, Color> onyxColors = {
  100: Color(0xFF171717),
};

const Map<int, Color> tColors = {
  100: Color(0xFF242E38),
};

const Map<int, Color> t2Colors = {
  100: Color(0xFF808080),
};

const Map<int, Color> greyColors = {
  100: Color(0xFFF5F5F5),
};

const Map<int, Color> redColors = {
  100: Color(0xFFD83030),
};

const MaterialColor primary = MaterialColor(0xFF2A5C99, primaryColors);
const MaterialColor secondary = MaterialColor(0xFFEAC43D, secondaryColors);
const MaterialColor b1 = MaterialColor(0xFF14C0CC, b1Colors);
const MaterialColor b2 = MaterialColor(0xFFA6CD4E, b2Colors);
const MaterialColor b3 = MaterialColor(0xFFD83030, redColors);
const MaterialColor onyx = MaterialColor(0xFF171717, onyxColors);
const MaterialColor text1 = MaterialColor(0xFF242E38, tColors);
const MaterialColor text2 = MaterialColor(0xFF808080, t2Colors);
const MaterialColor grey = MaterialColor(0xFFF5F5F5, greyColors);
const Color black = Colors.black;
const Color white = Colors.white;

Color generateAvatarColor(String name) {
  final int hashCode = name.hashCode;
  final Random random = Random(hashCode);
  final int r = random.nextInt(255);
  final int g = random.nextInt(255);
  final int b = random.nextInt(255);
  return Color.fromARGB(255, r, g, b);
}

Color generateAvatarContrast(Color color) {
  final luminance =
      (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
  return luminance > 0.5 ? Colors.black : Colors.white;
}

Future<Color> getContrastColor(MaterialColor color) async {
  // Calculate the relative luminance of the color
  double luminance =
      (0.2126 * color.red + 0.7152 * color.green + 0.0722 * color.blue) / 255;

  // Check if the color is light or dark
  if (luminance > 0.5) {
    return black;
  } else {
    return white;
  }
}

MaterialStateProperty<Color?> greyColor =
    MaterialStateProperty.resolveWith<Color?>(
  (Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return grey.shade100;
    } else {
      return grey;
    }
  },
);

MaterialStateProperty<Color?> primaryColor =
    MaterialStateProperty.resolveWith<Color?>(
  (Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return primary.shade500;
    } else {
      return primary;
    }
  },
);

Future<MaterialColor> getMaterialColor(String colorString) async {
  String hexString = colorString.replaceAll("Color(", "").replaceAll(")", "");
  Color color = Color(int.parse(hexString));
  MaterialColor materialColor = MaterialColor(color.value, {
    50: color.withOpacity(0.1),
    100: color.withOpacity(0.2),
    200: color.withOpacity(0.3),
    300: color.withOpacity(0.4),
    400: color.withOpacity(0.5),
    500: color.withOpacity(0.6),
    600: color.withOpacity(0.7),
    700: color.withOpacity(0.8),
    800: color.withOpacity(0.9),
    900: color.withOpacity(1.0),
  });
  return materialColor;
}

ThemeData getThemeData(BuildContext context, MaterialColor mainColor) =>
    ThemeData(
      primarySwatch: mainColor,
      iconTheme: const IconThemeData(
        color: text1,
      ),
      dividerColor: text2,
      textTheme: GoogleFonts.notoSansTextTheme(
        Theme.of(
          context,
        ).textTheme,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: mainColor,
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
