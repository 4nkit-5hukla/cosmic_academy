import 'package:flutter/material.dart';
import 'package:cosmic_assessments/common/widgets/spacer/spacer.dart';

class Display1 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final bool italic;
  final bool bold;
  final bool underline;

  const Display1({
    super.key,
    required this.text,
    this.textAlign = TextAlign.left,
    this.color,
    this.italic = false,
    this.bold = true,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: 45,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontFamily: "Noto Sans",
        fontWeight: bold ? FontWeight.w400 : FontWeight.w400,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }
}

class Display2 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final bool italic;
  final bool bold;
  final bool underline;

  const Display2({
    super.key,
    required this.text,
    this.textAlign = TextAlign.left,
    this.color,
    this.italic = false,
    this.bold = true,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: 40,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontFamily: "Noto Sans",
        fontWeight: bold ? FontWeight.w400 : FontWeight.w400,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }
}

class Heading1 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final bool italic;
  final bool bold;
  final bool underline;

  const Heading1({
    super.key,
    required this.text,
    this.textAlign = TextAlign.left,
    this.color,
    this.italic = false,
    this.bold = true,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: 27,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontFamily: "Noto Sans",
        fontWeight: bold ? FontWeight.w900 : FontWeight.w400,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }
}

class Heading2 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final bool italic;
  final bool bold;
  final bool underline;

  const Heading2({
    super.key,
    required this.text,
    this.textAlign = TextAlign.left,
    this.color,
    this.italic = false,
    this.bold = true,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: 25,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontFamily: "Noto Sans",
        fontWeight: bold ? FontWeight.w900 : FontWeight.w400,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }
}

class Heading3 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final bool italic;
  final bool bold;
  final bool underline;

  const Heading3({
    super.key,
    required this.text,
    this.textAlign = TextAlign.left,
    this.color,
    this.italic = false,
    this.bold = true,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: 23,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontFamily: "Noto Sans",
        fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }
}

class Heading4 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final bool italic;
  final bool bold;
  final FontWeight? fontWeight;
  final bool underline;

  const Heading4({
    super.key,
    required this.text,
    this.textAlign = TextAlign.left,
    this.color,
    this.italic = false,
    this.bold = true,
    this.underline = false,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: 19,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontFamily: "Noto Sans",
        fontWeight: bold
            ? fontWeight ?? FontWeight.w500
            : fontWeight ?? FontWeight.w400,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }
}

class Body1 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final bool italic;
  final bool bold;
  final bool underline;

  const Body1({
    super.key,
    required this.text,
    this.textAlign = TextAlign.left,
    this.color,
    this.italic = false,
    this.bold = false,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: 15,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontFamily: "Noto Sans",
        fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }
}

class Body2 extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final bool italic;
  final bool bold;
  final bool underline;

  const Body2({
    super.key,
    required this.text,
    this.textAlign = TextAlign.left,
    this.color,
    this.italic = false,
    this.bold = false,
    this.underline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        fontFamily: "Noto Sans",
        fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const MenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 30, color: color),
        spaceH10,
        Heading2(text: label, bold: false, color: color),
      ],
    );
  }
}
