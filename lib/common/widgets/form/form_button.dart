import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final double height;
  final Color buttonText;

  const FormButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.buttonText = Colors.white,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: buttonText,
        ),
        child: Text(
          label,
        ),
      ),
    );
  }
}
